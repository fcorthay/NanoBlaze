LIBRARY ieee;
  USE ieee.std_logic_1164.all;
  USE ieee.numeric_std.all;

LIBRARY NanoBlaze;

ARCHITECTURE struct OF nanoProcessor IS

   -- Architecture declarations
   constant aluCodeBitNb: positive := 5;
   constant opCodeBitNb: positive := 5;
   constant branchCondBitNb: positive := 3;
   constant intCodeBitNb: positive := 5;

   -- Internal signal declarations
   SIGNAL addrA             : unsigned( registerAddressBitNb-1 DOWNTO 0 );
   SIGNAL addrB             : unsigned( registerAddressBitNb-1 DOWNTO 0 );
   SIGNAL aluCode           : std_ulogic_vector( aluCodeBitNb-1 DOWNTO 0 );
   SIGNAL branchCond        : std_ulogic_vector(branchCondBitNb-1 DOWNTO 0);
   SIGNAL cIn               : std_ulogic;
   SIGNAL cOut              : std_ulogic;
   SIGNAL incPC             : std_ulogic;
   SIGNAL instrAddress      : unsigned( programCounterBitNb-1 DOWNTO 0 );
   SIGNAL instrData         : signed( registerBitNb-1 DOWNTO 0 );
   SIGNAL instrDataSel      : std_ulogic;
   SIGNAL instrString       : string(1 TO 16);
   SIGNAL intCode           : std_ulogic_vector( intCodeBitNb-1 DOWNTO 0 );
   SIGNAL loadInstrAddress  : std_ulogic;
   SIGNAL loadStoredPC      : std_ulogic;
   SIGNAL opCode            : std_ulogic_vector( opCodeBitNb-1 DOWNTO 0 );
   SIGNAL portIn            : signed( registerBitNb-1 DOWNTO 0 );
   SIGNAL portInSel         : std_ulogic;
   SIGNAL portIndexedSel    : std_ulogic;
   SIGNAL portInstrAddress  : unsigned(addressBitNb-1 DOWNTO 0);
   SIGNAL portOut           : signed( registerBitNb-1 DOWNTO 0 );
   SIGNAL portRegAddress    : unsigned(addressBitNb-1 DOWNTO 0);
   SIGNAL prevPC            : std_ulogic;
   SIGNAL regWrite          : std_ulogic;
   SIGNAL registerFileSel   : std_ulogic;
   SIGNAL scratchpadSel     : std_ulogic;
   SIGNAL scratchpadWrite   : std_ulogic;
   SIGNAL spadAddress       : unsigned(scratchpadAddressBitNb-1 DOWNTO 0);
   SIGNAL spadIn            : signed(registerBitNb-1 DOWNTO 0);
   SIGNAL spadIndexedSel    : std_ulogic;
   SIGNAL spadInstrAddress  : unsigned(scratchpadAddressBitNb-1 DOWNTO 0);
   SIGNAL spadOut           : signed(registerBitNb-1 DOWNTO 0);
   SIGNAL spadRegAddress    : unsigned(scratchpadAddressBitNb-1 DOWNTO 0);
   SIGNAL storePC           : std_ulogic;
   SIGNAL storedProgCounter : unsigned( programCounterBitNb-1 DOWNTO 0 );
   SIGNAL twoRegInstr       : std_ulogic;
   SIGNAL zero              : std_ulogic;

   SIGNAL progCounter_internal : unsigned ( programCounterBitNb-1 DOWNTO 0 );

   COMPONENT aluAndRegs
   GENERIC (
      registerBitNb          : positive := 8;
      registerAddressBitNb   : positive := 4;
      aluCodeBitNb           : positive := 5;
      portAddressBitNb       : positive := 8;
      scratchpadAddressBitNb : natural  := 4
   );
   PORT (
      addrA           : IN     unsigned ( registerAddressBitNb-1 DOWNTO 0 );
      addrB           : IN     unsigned ( registerAddressBitNb-1 DOWNTO 0 );
      aluCode         : IN     std_ulogic_vector ( aluCodeBitNb-1 DOWNTO 0 );
      cIn             : IN     std_ulogic ;
      clock           : IN     std_ulogic ;
      instrData       : IN     signed ( registerBitNb-1 DOWNTO 0 );
      instrDataSel    : IN     std_ulogic ;
      portIn          : IN     signed ( registerBitNb-1 DOWNTO 0 );
      portInSel       : IN     std_ulogic ;
      regWrite        : IN     std_ulogic ;
      registerFileSel : IN     std_ulogic ;
      reset           : IN     std_ulogic ;
      scratchpadSel   : IN     std_ulogic ;
      spadIn          : IN     signed ( registerBitNb-1 DOWNTO 0 );
      cOut            : OUT    std_ulogic ;
      portAddr        : OUT    unsigned (portAddressBitNb-1 DOWNTO 0);
      portOut         : OUT    signed ( registerBitNb-1 DOWNTO 0 );
      scratchpadAddr  : OUT    unsigned (scratchpadAddressBitNb-1 DOWNTO 0);
      spadOut         : OUT    signed ( registerBitNb-1 DOWNTO 0 );
      zero            : OUT    std_ulogic 
   );
   END COMPONENT;
   COMPONENT branchStack
   GENERIC (
      programCounterBitNb : positive := 10;
      stackPointerBitNb   : positive := 5
   );
   PORT (
      clock             : IN     std_ulogic ;
      prevPC            : IN     std_ulogic ;
      progCounter       : IN     unsigned ( programCounterBitNb-1 DOWNTO 0 );
      reset             : IN     std_ulogic ;
      storePC           : IN     std_ulogic ;
      storedProgCounter : OUT    unsigned ( programCounterBitNb-1 DOWNTO 0 )
   );
   END COMPONENT;
   COMPONENT controller
   GENERIC (
      intCodeBitNb    : positive := 5;
      branchCondBitNb : positive := 3;
      opCodeBitNb     : positive := 5
   );
   PORT (
      branchCond       : IN     std_ulogic_vector ( branchCondBitNb-1 DOWNTO 0 );
      cOut             : IN     std_ulogic ;
      clock            : IN     std_ulogic ;
      en               : IN     std_ulogic ;
      int              : IN     std_uLogic ;
      intCode          : IN     std_ulogic_vector ( intCodeBitNb-1 DOWNTO 0 );
      opCode           : IN     std_ulogic_vector (opCodeBitNb-1 DOWNTO 0);
      reset            : IN     std_ulogic ;
      twoRegInstr      : IN     std_ulogic ;
      zero             : IN     std_ulogic ;
      cIn              : OUT    std_ulogic ;
      incPC            : OUT    std_ulogic ;
      instrDataSel     : OUT    std_ulogic ;
      intAck           : OUT    std_ulogic ;
      loadInstrAddress : OUT    std_ulogic ;
      loadStoredPC     : OUT    std_ulogic ;
      portInSel        : OUT    std_ulogic ;
      prevPC           : OUT    std_ulogic ;
      readStrobe       : OUT    std_uLogic ;
      regWrite         : OUT    std_ulogic ;
      registerFileSel  : OUT    std_ulogic ;
      scratchpadSel    : OUT    std_ulogic ;
      scratchpadWrite  : OUT    std_ulogic ;
      storePC          : OUT    std_ulogic ;
      writeStrobe      : OUT    std_uLogic 
   );
   END COMPONENT;
   COMPONENT instructionDecoder
   GENERIC (
      registerBitNb        : positive := 8;
      registerAddressBitNb : positive := 4;
      aluCodeBitNb         : positive := 5;
      instructionBitNb     : positive := 18;
      programCounterBitNb  : positive := 10;
      opCodeBitNb          : positive := 5;
      branchCondBitNb      : positive := 3;
      intCodeBitNb         : positive := 5;
      spadAddressBitNb     : natural  := 4;
      portAddressBitNb     : positive := 8
   );
   PORT (
      instruction    : IN     std_ulogic_vector ( instructionBitNb-1 DOWNTO 0 );
      addrA          : OUT    unsigned ( registerAddressBitNb-1 DOWNTO 0 );
      addrB          : OUT    unsigned ( registerAddressBitNb-1 DOWNTO 0 );
      aluCode        : OUT    std_ulogic_vector ( aluCodeBitNb-1 DOWNTO 0 );
      branchCond     : OUT    std_ulogic_vector (branchCondBitNb-1 DOWNTO 0);
      instrAddress   : OUT    unsigned ( programCounterBitNb-1 DOWNTO 0 );
      instrData      : OUT    signed ( registerBitNb-1 DOWNTO 0 );
      intCode        : OUT    std_ulogic_vector ( intCodeBitNb-1 DOWNTO 0 );
      opCode         : OUT    std_ulogic_vector ( opCodeBitNb-1 DOWNTO 0 );
      portAddress    : OUT    unsigned (portAddressBitNb-1 DOWNTO 0);
      portIndexedSel : OUT    std_ulogic ;
      spadAddress    : OUT    unsigned ( spadAddressBitNb-1 DOWNTO 0 );
      spadIndexedSel : OUT    std_ulogic ;
      twoRegInstr    : OUT    std_ulogic 
   );
   END COMPONENT;
   COMPONENT programCounter
   GENERIC (
      programCounterBitNb : positive := 10
   );
   PORT (
      clock             : IN     std_ulogic ;
      incPC             : IN     std_ulogic ;
      instrAddress      : IN     unsigned ( programCounterBitNb-1 DOWNTO 0 );
      loadInstrAddress  : IN     std_ulogic ;
      loadStoredPC      : IN     std_ulogic ;
      reset             : IN     std_ulogic ;
      storedProgCounter : IN     unsigned ( programCounterBitNb-1 DOWNTO 0 );
      progCounter       : OUT    unsigned ( programCounterBitNb-1 DOWNTO 0 )
   );
   END COMPONENT;
   COMPONENT scratchpad
   GENERIC (
      registerBitNb    : positive := 8;
      spadAddressBitNb : natural  := 4
   );
   PORT (
      addr    : IN     unsigned ( spadAddressBitNb-1 DOWNTO 0 );
      clock   : IN     std_ulogic ;
      dataIn  : IN     signed ( registerBitNb-1 DOWNTO 0 );
      reset   : IN     std_ulogic ;
      write   : IN     std_ulogic ;
      dataOut : OUT    signed ( registerBitNb-1 DOWNTO 0 )
   );
   END COMPONENT;

   -- Optional embedded configurations
   -- pragma synthesis_off
   FOR ALL : aluAndRegs USE ENTITY NanoBlaze.aluAndRegs;
   FOR ALL : branchStack USE ENTITY NanoBlaze.branchStack;
   FOR ALL : controller USE ENTITY NanoBlaze.controller;
   FOR ALL : instructionDecoder USE ENTITY NanoBlaze.instructionDecoder;
   FOR ALL : programCounter USE ENTITY NanoBlaze.programCounter;
   -- pragma synthesis_on


BEGIN
   dataAddress <= portInstrAddress when portIndexedSel = '0' else portRegAddress;
   dataOut <= std_ulogic_vector(portOut);
   portIn <= signed(dataIn);
   spadAddress <= spadInstrAddress when spadIndexedSel = '0' else spadRegAddress;
   
   process(instruction)
   
     constant bitsPerHexDigit : positive := 4;
   
     function pad(inString : string; outLength : positive) return string is
       variable outString : string(1 to outLength);
     begin
       outString := (others => ' ');
       outString(inString'range) := inString;
       return outString;
     end function pad;
   
     function hexDigitNb(bitNb : positive) return positive is
     begin
       return (bitNb-1)/bitsPerHexDigit+1;
     end function hexDigitNb;
       
     function to01(nineValued : unsigned) return unsigned is
       variable twoValued : unsigned(nineValued'range);
     begin
       twoValued := (others => '0');
       for index in nineValued'range loop
         if (nineValued(index) = '1') or (nineValued(index) = 'H') then
           twoValued(index) := '1';
         end if;
       end loop;
       return twoValued;
     end function to01;
   
     variable opCode : unsigned(1+opCodeBitNb-1 downto 0);
     variable destRegister : unsigned(registerAddressBitNb-1 downto 0);
     variable destRegisterString : string(1 to 1+hexDigitNb(registerAddressBitNb));
     variable sourceRegister : unsigned(registerAddressBitNb-1 downto 0);
     variable sourceRegisterString : string(1 to 1+hexDigitNb(registerAddressBitNb));
     variable sourceConstant : unsigned(registerBitNb-1 downto 0);
     variable sourceConstantString : string(1 to hexDigitNb(registerBitNb));
     variable branchAddress : unsigned(programCounterBitNb-1 downto 0);
     variable branchAddressString : string(1 to hexDigitNb(programCounterBitNb));
     variable branchKind : unsigned(1 downto 0);
     variable shRotCin : unsigned(2 downto 0);
     variable shRotDir: std_ulogic;
   
     function toHexDigit(binary : unsigned(bitsPerHexDigit-1 downto 0)) return character is
     begin
       if binary <= 9 then
         return character'val(character'pos('0') + to_integer(to01(binary)));
       else
         return character'val(character'pos('A') + to_integer(to01(binary)) - 10);
       end if;
     end function toHexDigit;
   
     function toHexString(binary : unsigned) return string is
       variable hexString : string(1 to hexDigitNb(binary'length));
     begin
       for index in hexString'high-1 downto 0 loop
         hexString(hexString'high-index) := toHexDigit(
           resize(shift_right(binary, bitsPerHexDigit*index), bitsPerHexDigit)
         );
       end loop;
       return hexString;
     end function toHexString;
   
   begin
   
     opCode := resize(
       shift_right(unsigned(instruction), instruction'length-opCode'length),
       opCode'length
     );
     destRegister := resize(
       shift_right(unsigned(instruction), instruction'length-opCode'length-destRegister'length),
       destRegister'length
     );
     destRegisterString := 's' & toHexDigit(destRegister);
     sourceRegister := resize(
       shift_right(unsigned(instruction), instruction'length-opCode'length-destRegister'length-sourceRegister'length),
       sourceRegister'length
     );
     sourceRegisterString := 's' & toHexDigit(sourceRegister);
     sourceConstant := resize(unsigned(instruction), sourceConstant'length);
     sourceConstantString := toHexString(sourceConstant);
     branchKind := resize(
       shift_right(unsigned(instruction), instruction'length-opCode'length-branchKind'length),
       branchKind'length
     );
     branchAddress := resize(unsigned(instruction), branchAddress'length);
     branchAddressString := toHexString(branchAddress);
     shRotCin := resize(shift_right(unsigned(instruction), 1), shRotCin'length);
     shRotDir := instruction(0);
   
     case opCode is
       when "000000" => instrString <= pad("LOAD " & destRegisterString & " " & sourceConstantString, instrString'length);
       when "000001" => instrString <= pad("LOAD " & destRegisterString & " " & sourceRegisterString, instrString'length);
       when "000100" => instrString <= pad("INPUT " & destRegisterString & " " & sourceConstantString, instrString'length);
       when "000101" => instrString <= pad("INPUT " & destRegisterString & " " & sourceRegisterString, instrString'length);
       when "000110" => instrString <= pad("FETCH " & destRegisterString & " " & sourceConstantString, instrString'length);
       when "000111" => instrString <= pad("FETCH " & destRegisterString & " " & sourceRegisterString, instrString'length);
       when "001010" => instrString <= pad("AND " & destRegisterString & " " & sourceConstantString, instrString'length);
       when "001011" => instrString <= pad("AND " & destRegisterString & " " & sourceRegisterString, instrString'length);
       when "001100" => instrString <= pad("OR " & destRegisterString & " " & sourceConstantString, instrString'length);
       when "001101" => instrString <= pad("OR " & destRegisterString & " " & sourceRegisterString, instrString'length);
       when "001110" => instrString <= pad("XOR " & destRegisterString & " " & sourceConstantString, instrString'length);
       when "001111" => instrString <= pad("XOR " & destRegisterString & " " & sourceRegisterString, instrString'length);
       when "010010" => instrString <= pad("TEST " & destRegisterString & " " & sourceConstantString, instrString'length);
       when "010011" => instrString <= pad("TEST " & destRegisterString & " " & sourceRegisterString, instrString'length);
       when "010100" => instrString <= pad("COMP " & destRegisterString & " " & sourceConstantString, instrString'length);
       when "010101" => instrString <= pad("COMP " & destRegisterString & " " & sourceRegisterString, instrString'length);
       when "011000" => instrString <= pad("ADD " & destRegisterString & " " & sourceConstantString, instrString'length);
       when "011001" => instrString <= pad("ADD " & destRegisterString & " " & sourceRegisterString, instrString'length);
       when "011010" => instrString <= pad("ADDCY " & destRegisterString & " " & sourceConstantString, instrString'length);
       when "011011" => instrString <= pad("ADDCY " & destRegisterString & " " & sourceRegisterString, instrString'length);
       when "011100" => instrString <= pad("SUB " & destRegisterString & " " & sourceConstantString, instrString'length);
       when "011101" => instrString <= pad("SUB " & destRegisterString & " " & sourceRegisterString, instrString'length);
       when "011110" => instrString <= pad("SUBCY " & destRegisterString & " " & sourceConstantString, instrString'length);
       when "011111" => instrString <= pad("SUBCY " & destRegisterString & " " & sourceRegisterString, instrString'length);
       when "100000" =>
         case shRotCin is
           when "000"  => instrString <= pad("SLA " & destRegisterString, instrString'length);
           when "001"  => instrString <= pad("RL " & destRegisterString, instrString'length);
           when "010"  => instrString <= pad("SLX " & destRegisterString, instrString'length);
           when "011"  =>
             case shRotDir is
               when '0'    => instrString <= pad("SL0 " & destRegisterString, instrString'length);
               when '1'    => instrString <= pad("SL1 " & destRegisterString, instrString'length);
               when others => instrString <= pad("--------", instrString'length);
             end case;
           when "100"  => instrString <= pad("SRA " & destRegisterString, instrString'length);
           when "101"  => instrString <= pad("SRX " & destRegisterString, instrString'length);
           when "110"  => instrString <= pad("RR " & destRegisterString, instrString'length);
           when "111"  =>
             case shRotDir is
               when '0'    => instrString <= pad("SR0 " & destRegisterString, instrString'length);
               when '1'    => instrString <= pad("SR1 " & destRegisterString, instrString'length);
               when others => instrString <= pad("--------", instrString'length);
             end case;
           when others => instrString <= pad("--------", instrString'length);
         end case;
       when "101100" => instrString <= pad("OUTPUT " & destRegisterString & " " & sourceConstantString, instrString'length);
       when "101101" => instrString <= pad("OUTPUT " & destRegisterString & " (" & sourceRegisterString & ")", instrString'length);
       when "101110" => instrString <= pad("STORE " & destRegisterString & " " & sourceConstantString, instrString'length);
       when "101111" => instrString <= pad("STORE " & destRegisterString & " (" & sourceRegisterString & ")", instrString'length);
       when "101010" => instrString <= pad("RET", instrString'length);
       when "101011" =>
         case branchKind is
           when "00"   => instrString <= pad("RET Z", instrString'length);
           when "01"   => instrString <= pad("RET NZ", instrString'length);
           when "10"   => instrString <= pad("RET C", instrString'length);
           when "11"   => instrString <= pad("RET NC", instrString'length);
           when others => instrString <= pad("--------", instrString'length);
         end case;
       when "110000" => instrString <= pad("CALL " & branchAddressString, instrString'length);
       when "110001" =>
         case branchKind is
           when "00"   => instrString <= pad("CALL Z " & branchAddressString, instrString'length);
           when "01"   => instrString <= pad("CALL NZ " & branchAddressString, instrString'length);
           when "10"   => instrString <= pad("CALL C " & branchAddressString, instrString'length);
           when "11"   => instrString <= pad("CALL NC " & branchAddressString, instrString'length);
           when others => instrString <= pad("--------", instrString'length);
         end case;
       when "110100" => instrString <= pad("JUMP " & branchAddressString, instrString'length);
       when "110101" =>
         case branchKind is
           when "00"   => instrString <= pad("JUMP Z " & branchAddressString, instrString'length);
           when "01"   => instrString <= pad("JUMP NZ " & branchAddressString, instrString'length);
           when "10"   => instrString <= pad("JUMP C " & branchAddressString, instrString'length);
           when "11"   => instrString <= pad("JUMP NC " & branchAddressString, instrString'length);
           when others => instrString <= pad("--------", instrString'length);
         end case;
       when others   => instrString <= pad("--------", instrString'length);
     end case;
   
   end process;

    I_alu : aluAndRegs
      GENERIC MAP (
         registerBitNb          => registerBitNb,
         registerAddressBitNb   => registerAddressBitNb,
         aluCodeBitNb           => aluCodeBitNb,
         portAddressBitNb       => addressBitNb,
         scratchpadAddressBitNb => scratchpadAddressBitNb
      )
      PORT MAP (
         addrA           => addrA,
         addrB           => addrB,
         aluCode         => aluCode,
         cIn             => cIn,
         clock           => clock,
         instrData       => instrData,
         instrDataSel    => instrDataSel,
         portIn          => portIn,
         portInSel       => portInSel,
         regWrite        => regWrite,
         registerFileSel => registerFileSel,
         reset           => reset,
         scratchpadSel   => scratchpadSel,
         spadIn          => spadIn,
         cOut            => cOut,
         portAddr        => portRegAddress,
         portOut         => portOut,
         scratchpadAddr  => spadRegAddress,
         spadOut         => spadOut,
         zero            => zero
      );
   I_BR : branchStack
      GENERIC MAP (
         programCounterBitNb => programCounterBitNb,
         stackPointerBitNb   => stackPointerBitNb
      )
      PORT MAP (
         clock             => clock,
         prevPC            => prevPC,
         progCounter       => progCounter_internal,
         reset             => reset,
         storePC           => storePC,
         storedProgCounter => storedProgCounter
      );
   I_ctrl : controller
      GENERIC MAP (
         intCodeBitNb    => 5,
         branchCondBitNb => branchCondBitNb,
         opCodeBitNb     => opCodeBitNb
      )
      PORT MAP (
         branchCond       => branchCond,
         cOut             => cOut,
         clock            => clock,
         en               => en,
         int              => int,
         intCode          => intCode,
         opCode           => opCode,
         reset            => reset,
         twoRegInstr      => twoRegInstr,
         zero             => zero,
         cIn              => cIn,
         incPC            => incPC,
         instrDataSel     => instrDataSel,
         intAck           => intAck,
         loadInstrAddress => loadInstrAddress,
         loadStoredPC     => loadStoredPC,
         portInSel        => portInSel,
         prevPC           => prevPC,
         readStrobe       => readStrobe,
         regWrite         => regWrite,
         registerFileSel  => registerFileSel,
         scratchpadSel    => scratchpadSel,
         scratchpadWrite  => scratchpadWrite,
         storePC          => storePC,
         writeStrobe      => writeStrobe
      );
   I_instr : instructionDecoder
      GENERIC MAP (
         registerBitNb        => registerBitNb,
         registerAddressBitNb => registerAddressBitNb,
         aluCodeBitNb         => aluCodeBitNb,
         instructionBitNb     => instructionBitNb,
         programCounterBitNb  => programCounterBitNb,
         opCodeBitNb          => opCodeBitNb,
         branchCondBitNb      => branchCondBitNb,
         intCodeBitNb         => 5,
         spadAddressBitNb     => scratchpadAddressBitNb,
         portAddressBitNb     => addressBitNb
      )
      PORT MAP (
         instruction    => instruction,
         addrA          => addrA,
         addrB          => addrB,
         aluCode        => aluCode,
         branchCond     => branchCond,
         instrAddress   => instrAddress,
         instrData      => instrData,
         intCode        => intCode,
         opCode         => opCode,
         portAddress    => portInstrAddress,
         portIndexedSel => portIndexedSel,
         spadAddress    => spadInstrAddress,
         spadIndexedSel => spadIndexedSel,
         twoRegInstr    => twoRegInstr
      );
   I_PC : programCounter
      GENERIC MAP (
         programCounterBitNb => programCounterBitNb
      )
      PORT MAP (
         clock             => clock,
         incPC             => incPC,
         instrAddress      => instrAddress,
         loadInstrAddress  => loadInstrAddress,
         loadStoredPC      => loadStoredPC,
         reset             => reset,
         storedProgCounter => storedProgCounter,
         progCounter       => progCounter_internal
      );

   g_scratchpad: IF scratchpadAddressBitNb > 0 GENERATE
   FOR ALL : scratchpad USE ENTITY NanoBlaze.scratchpad;

   BEGIN
      I_sPad : scratchpad
         GENERIC MAP (
            registerBitNb    => registerBitNb,
            spadAddressBitNb => scratchpadAddressBitNb
         )
         PORT MAP (
            addr    => spadAddress,
            clock   => clock,
            dataIn  => spadOut,
            reset   => reset,
            write   => scratchpadWrite,
            dataOut => spadIn
         );
   END;
   END GENERATE g_scratchpad;

   progCounter <= progCounter_internal;

END struct;
