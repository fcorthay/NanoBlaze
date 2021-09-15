LIBRARY ieee;
  USE ieee.std_logic_1164.all;
  USE ieee.numeric_std.all;

LIBRARY NanoBlaze;
LIBRARY NanoBlaze_test;

ARCHITECTURE struct OF nanoBlaze_tb IS

   constant addressBitNb: positive := 8;
   constant dataBitNb: positive := 8;
   constant programCounterBitNb: positive := 10;
   constant stackPointerBitNb: positive := 5;
   constant registerAddressBitNb: positive := 4;
   constant portAddressBitNb: positive := 8;
   constant scratchpadAddressBitNb: positive := 4;

   SIGNAL clock       : std_ulogic;
   SIGNAL dataAddress : unsigned( addressBitNb-1 DOWNTO 0 );
   SIGNAL dataIn      : std_ulogic_vector(dataBitNb-1 DOWNTO 0);
   SIGNAL dataOut     : std_ulogic_vector(dataBitNb-1 DOWNTO 0);
   SIGNAL en          : std_ulogic;
   SIGNAL int         : std_uLogic;
   SIGNAL intAck      : std_ulogic;
   SIGNAL readStrobe  : std_uLogic;
   SIGNAL reset       : std_ulogic;
   SIGNAL writeStrobe : std_uLogic;

   COMPONENT nanoBlaze
   GENERIC (
      addressBitNb           : positive := 8;
      registerBitNb          : positive := 8;
      programCounterBitNb    : positive := 10;
      stackPointerBitNb      : positive := 5;
      registerAddressBitNb   : positive := 4;
      scratchpadAddressBitNb : natural  := 6
   );
   PORT (
      clock       : IN     std_ulogic ;
      dataIn      : IN     std_ulogic_vector (registerBitNb-1 DOWNTO 0);
      en          : IN     std_ulogic ;
      int         : IN     std_uLogic ;
      reset       : IN     std_ulogic ;
      dataAddress : OUT    unsigned ( addressBitNb-1 DOWNTO 0 );
      dataOut     : OUT    std_ulogic_vector (registerBitNb-1 DOWNTO 0);
      intAck      : OUT    std_ulogic ;
      readStrobe  : OUT    std_uLogic ;
      writeStrobe : OUT    std_uLogic 
   );
   END COMPONENT;
   COMPONENT nanoBlaze_tester
   GENERIC (
      addressBitNb : positive := 8;
      dataBitNb    : positive := 8
   );
   PORT (
      dataAddress : IN     unsigned ( addressBitNb-1 DOWNTO 0 );
      dataOut     : IN     std_ulogic_vector (dataBitNb-1 DOWNTO 0);
      intAck      : IN     std_ulogic ;
      readStrobe  : IN     std_uLogic ;
      writeStrobe : IN     std_uLogic ;
      clock       : OUT    std_ulogic ;
      dataIn      : OUT    std_ulogic_vector (dataBitNb-1 DOWNTO 0);
      en          : OUT    std_ulogic ;
      int         : OUT    std_uLogic ;
      reset       : OUT    std_ulogic 
   );
   END COMPONENT;

   FOR ALL : nanoBlaze USE ENTITY NanoBlaze.nanoBlaze;
   FOR ALL : nanoBlaze_tester USE ENTITY NanoBlaze_test.nanoBlaze_tester;

BEGIN

   I_DUT : nanoBlaze
      GENERIC MAP (
         addressBitNb           => addressBitNb,
         registerBitNb          => dataBitNb,
         programCounterBitNb    => programCounterBitNb,
         stackPointerBitNb      => stackPointerBitNb,
         registerAddressBitNb   => registerAddressBitNb,
         scratchpadAddressBitNb => scratchpadAddressBitNb
      )
      PORT MAP (
         clock       => clock,
         dataIn      => dataIn,
         en          => en,
         int         => int,
         reset       => reset,
         dataAddress => dataAddress,
         dataOut     => dataOut,
         intAck      => intAck,
         readStrobe  => readStrobe,
         writeStrobe => writeStrobe
      );

   I_tb : nanoBlaze_tester
      GENERIC MAP (
         addressBitNb => addressBitNb,
         dataBitNb    => dataBitNb
      )
      PORT MAP (
         dataAddress => dataAddress,
         dataOut     => dataOut,
         intAck      => intAck,
         readStrobe  => readStrobe,
         writeStrobe => writeStrobe,
         clock       => clock,
         dataIn      => dataIn,
         en          => en,
         int         => int,
         reset       => reset
      );

END struct;
