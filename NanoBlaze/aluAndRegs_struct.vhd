LIBRARY ieee;
  USE ieee.std_logic_1164.all;
  USE ieee.numeric_std.all;

LIBRARY NanoBlaze;

ARCHITECTURE struct OF aluAndRegs IS

   SIGNAL aluOut         : signed(registerBitNb-1 DOWNTO 0);
   SIGNAL opA            : signed(registerBitNb-1 DOWNTO 0);
   SIGNAL opB            : signed(registerBitNb-1 DOWNTO 0);
   SIGNAL registerFileIn : signed(registerBitNb-1 DOWNTO 0);

   COMPONENT alu
   GENERIC (
      aluCodeBitNb : positive := 5;
      dataBitNb    : positive := 8
   );
   PORT (
      aluCode : IN     std_ulogic_vector ( aluCodeBitNb-1 DOWNTO 0 );
      cIn     : IN     std_ulogic ;
      opA     : IN     signed ( dataBitNb-1 DOWNTO 0 );
      opB     : IN     signed ( dataBitNb-1 DOWNTO 0 );
      aluOut  : OUT    signed ( dataBitNb-1 DOWNTO 0 );
      cOut    : OUT    std_ulogic ;
      zero    : OUT    std_ulogic 
   );
   END COMPONENT;
   COMPONENT aluBOpSelector
   GENERIC (
      registerBitNb : positive := 8
   );
   PORT (
      instrData       : IN     signed ( registerBitNb-1 DOWNTO 0 );
      instrDataSel    : IN     std_ulogic ;
      portIn          : IN     signed ( registerBitNb-1 DOWNTO 0 );
      portInSel       : IN     std_ulogic ;
      registerFileIn  : IN     signed ( registerBitNb-1 DOWNTO 0 );
      registerFileSel : IN     std_ulogic ;
      scratchpadSel   : IN     std_ulogic ;
      spadIn          : IN     signed ( registerBitNb-1 DOWNTO 0 );
      opB             : OUT    signed (registerBitNb-1 DOWNTO 0)
   );
   END COMPONENT;
   COMPONENT registerFile
   GENERIC (
      registerAddressBitNb : positive := 4;
      dataBitNb            : positive := 8
   );
   PORT (
      addrA       : IN     unsigned ( registerAddressBitNb-1 DOWNTO 0 );
      addrB       : IN     unsigned ( registerAddressBitNb-1 DOWNTO 0 );
      clock       : IN     std_ulogic ;
      regWrite    : IN     std_ulogic ;
      registersIn : IN     signed ( dataBitNb-1 DOWNTO 0 );
      reset       : IN     std_ulogic ;
      opA         : OUT    signed ( dataBitNb-1 DOWNTO 0 );
      opB         : OUT    signed ( dataBitNb-1 DOWNTO 0 )
   );
   END COMPONENT;

   FOR ALL : alu USE ENTITY NanoBlaze.alu;
   FOR ALL : aluBOpSelector USE ENTITY NanoBlaze.aluBOpSelector;
   FOR ALL : registerFile USE ENTITY NanoBlaze.registerFile;

BEGIN
   portOut <= opA;
   spadOut <= opA;
   portAddr <= resize(unsigned(registerFileIn), portAddressBitNb);
   scratchpadAddr <= resize(unsigned(registerFileIn), scratchpadAddressBitNb);

   I_ALU : alu
      GENERIC MAP (
         aluCodeBitNb => aluCodeBitNb,
         dataBitNb    => registerBitNb
      )
      PORT MAP (
         aluCode => aluCode,
         cIn     => cIn,
         opA     => opA,
         opB     => opB,
         aluOut  => aluOut,
         cOut    => cOut,
         zero    => zero
      );
   I_bSel : aluBOpSelector
      GENERIC MAP (
         registerBitNb => registerBitNb
      )
      PORT MAP (
         instrData       => instrData,
         instrDataSel    => instrDataSel,
         portIn          => portIn,
         portInSel       => portInSel,
         registerFileIn  => registerFileIn,
         registerFileSel => registerFileSel,
         scratchpadSel   => scratchpadSel,
         spadIn          => spadIn,
         opB             => opB
      );
   I_regs : registerFile
      GENERIC MAP (
         registerAddressBitNb => registerAddressBitNb,
         dataBitNb            => registerBitNb
      )
      PORT MAP (
         addrA       => addrA,
         addrB       => addrB,
         clock       => clock,
         regWrite    => regWrite,
         registersIn => aluOut,
         reset       => reset,
         opA         => opA,
         opB         => registerFileIn
      );

END struct;
