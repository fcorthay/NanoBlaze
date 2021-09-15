LIBRARY ieee;
  USE ieee.std_logic_1164.all;
  USE ieee.numeric_std.all;

ENTITY nanoBlaze IS
   GENERIC( 
      addressBitNb           : positive := 8;
      registerBitNb          : positive := 8;
      programCounterBitNb    : positive := 10;
      stackPointerBitNb      : positive := 5;
      registerAddressBitNb   : positive := 4;
      scratchpadAddressBitNb : natural  := 6
   );
   PORT( 
      clock       : IN     std_ulogic;
      dataIn      : IN     std_ulogic_vector (registerBitNb-1 DOWNTO 0);
      en          : IN     std_ulogic;
      int         : IN     std_uLogic;
      reset       : IN     std_ulogic;
      dataAddress : OUT    unsigned ( addressBitNb-1 DOWNTO 0 );
      dataOut     : OUT    std_ulogic_vector (registerBitNb-1 DOWNTO 0);
      intAck      : OUT    std_ulogic;
      readStrobe  : OUT    std_uLogic;
      writeStrobe : OUT    std_uLogic
   );

END nanoBlaze;
