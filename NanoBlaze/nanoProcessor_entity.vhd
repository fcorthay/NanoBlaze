LIBRARY ieee;
  USE ieee.std_logic_1164.all;
  USE ieee.numeric_std.all;

ENTITY nanoProcessor IS
   GENERIC( 
      addressBitNb           : positive := 8;
      registerBitNb          : positive := 8;
      registerAddressBitNb   : positive := 4;
      programCounterBitNb    : positive := 10;
      stackPointerBitNb      : positive := 5;
      instructionBitNb       : positive := 18;
      scratchpadAddressBitNb : natural  := 4
   );
   PORT( 
      clock       : IN     std_ulogic;
      dataIn      : IN     std_ulogic_vector (registerBitNb-1 DOWNTO 0);
      en          : IN     std_ulogic;
      instruction : IN     std_ulogic_vector (instructionBitNb-1 DOWNTO 0);
      int         : IN     std_uLogic;
      reset       : IN     std_ulogic;
      dataAddress : OUT    unsigned (addressBitNb-1 DOWNTO 0);
      dataOut     : OUT    std_ulogic_vector (registerBitNb-1 DOWNTO 0);
      intAck      : OUT    std_ulogic;
      progCounter : OUT    unsigned ( programCounterBitNb-1 DOWNTO 0 );
      readStrobe  : OUT    std_uLogic;
      writeStrobe : OUT    std_uLogic
   );

END nanoProcessor;
