LIBRARY ieee;
  USE ieee.std_logic_1164.all;
  USE ieee.numeric_std.all;

ENTITY branchStack IS
   GENERIC( 
      programCounterBitNb : positive := 10;
      stackPointerBitNb   : positive := 5
   );
   PORT( 
      clock             : IN     std_ulogic;
      prevPC            : IN     std_ulogic;
      progCounter       : IN     unsigned ( programCounterBitNb-1 DOWNTO 0 );
      reset             : IN     std_ulogic;
      storePC           : IN     std_ulogic;
      storedProgCounter : OUT    unsigned ( programCounterBitNb-1 DOWNTO 0 )
   );

END branchStack;
