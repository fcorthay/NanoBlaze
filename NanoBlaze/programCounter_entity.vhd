LIBRARY ieee;
  USE ieee.std_logic_1164.all;
  USE ieee.numeric_std.all;

ENTITY programCounter IS
   GENERIC( 
      programCounterBitNb : positive := 10
   );
   PORT( 
      clock             : IN     std_ulogic;
      incPC             : IN     std_ulogic;
      instrAddress      : IN     unsigned ( programCounterBitNb-1 DOWNTO 0 );
      loadInstrAddress  : IN     std_ulogic;
      loadStoredPC      : IN     std_ulogic;
      reset             : IN     std_ulogic;
      storedProgCounter : IN     unsigned ( programCounterBitNb-1 DOWNTO 0 );
      progCounter       : OUT    unsigned ( programCounterBitNb-1 DOWNTO 0 )
   );

END programCounter;
