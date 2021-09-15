LIBRARY ieee;
  USE ieee.std_logic_1164.all;
  USE ieee.numeric_std.all;

LIBRARY NanoBlaze;

ARCHITECTURE struct OF nanoBlaze IS

   constant instructionBitNb: positive := 18;
   SIGNAL instruction    : std_ulogic_vector(instructionBitNb-1 DOWNTO 0);
   SIGNAL logic1         : std_ulogic;
   SIGNAL programCounter : unsigned(programCounterBitNb-1 DOWNTO 0);

   COMPONENT nanoProcessor
   GENERIC (
      addressBitNb           : positive := 8;
      registerBitNb          : positive := 8;
      registerAddressBitNb   : positive := 4;
      programCounterBitNb    : positive := 10;
      stackPointerBitNb      : positive := 5;
      instructionBitNb       : positive := 18;
      scratchpadAddressBitNb : natural  := 4
   );
   PORT (
      clock       : IN     std_ulogic ;
      dataIn      : IN     std_ulogic_vector (registerBitNb-1 DOWNTO 0);
      en          : IN     std_ulogic ;
      instruction : IN     std_ulogic_vector (instructionBitNb-1 DOWNTO 0);
      int         : IN     std_uLogic ;
      reset       : IN     std_ulogic ;
      dataAddress : OUT    unsigned (addressBitNb-1 DOWNTO 0);
      dataOut     : OUT    std_ulogic_vector (registerBitNb-1 DOWNTO 0);
      intAck      : OUT    std_ulogic ;
      progCounter : OUT    unsigned ( programCounterBitNb-1 DOWNTO 0 );
      readStrobe  : OUT    std_uLogic ;
      writeStrobe : OUT    std_uLogic 
   );
   END COMPONENT;
   COMPONENT programRom
   GENERIC (
      addressBitNb : positive := 8;
      dataBitNb    : positive := 8
   );
   PORT (
      address : IN     unsigned (addressBitNb-1 DOWNTO 0);
      clock   : IN     std_ulogic ;
      en      : IN     std_ulogic ;
      reset   : IN     std_ulogic ;
      dataOut : OUT    std_ulogic_vector ( dataBitNb-1 DOWNTO 0 )
   );
   END COMPONENT;

   FOR ALL : nanoProcessor USE ENTITY NanoBlaze.nanoProcessor;
   FOR ALL : programRom USE ENTITY NanoBlaze.programRom;

BEGIN
   logic1 <= '1';

   I_up : nanoProcessor
      GENERIC MAP (
         addressBitNb           => addressBitNb,
         registerBitNb          => registerBitNb,
         registerAddressBitNb   => registerAddressBitNb,
         programCounterBitNb    => programCounterBitNb,
         stackPointerBitNb      => stackPointerBitNb,
         instructionBitNb       => instructionBitNb,
         scratchpadAddressBitNb => scratchpadAddressBitNb
      )
      PORT MAP (
         clock       => clock,
         dataIn      => dataIn,
         en          => en,
         instruction => instruction,
         int         => int,
         reset       => reset,
         dataAddress => dataAddress,
         dataOut     => dataOut,
         intAck      => intAck,
         progCounter => programCounter,
         readStrobe  => readStrobe,
         writeStrobe => writeStrobe
      );
   I_rom : programRom
      GENERIC MAP (
         addressBitNb => programCounterBitNb,
         dataBitNb    => instructionBitNb
      )
      PORT MAP (
         address => programCounter,
         clock   => clock,
         en      => logic1,
         reset   => reset,
         dataOut => instruction
      );

END struct;
