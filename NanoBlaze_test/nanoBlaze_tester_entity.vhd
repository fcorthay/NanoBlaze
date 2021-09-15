LIBRARY ieee;
  USE ieee.std_logic_1164.all;
  USE ieee.numeric_std.all;

ENTITY nanoBlaze_tester IS
   GENERIC( 
      addressBitNb : positive := 8;
      dataBitNb    : positive := 8
   );
   PORT( 
      dataAddress : IN     unsigned ( addressBitNb-1 DOWNTO 0 );
      dataOut     : IN     std_ulogic_vector (dataBitNb-1 DOWNTO 0);
      intAck      : IN     std_ulogic;
      readStrobe  : IN     std_uLogic;
      writeStrobe : IN     std_uLogic;
      clock       : OUT    std_ulogic;
      dataIn      : OUT    std_ulogic_vector (dataBitNb-1 DOWNTO 0);
      en          : OUT    std_ulogic;
      int         : OUT    std_uLogic;
      reset       : OUT    std_ulogic
   );

END nanoBlaze_tester;
