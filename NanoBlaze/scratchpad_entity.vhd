LIBRARY ieee;
  USE ieee.std_logic_1164.all;
  USE ieee.numeric_std.all;

ENTITY scratchpad IS
   GENERIC( 
      registerBitNb    : positive := 8;
      spadAddressBitNb : natural  := 4
   );
   PORT( 
      addr    : IN     unsigned ( spadAddressBitNb-1 DOWNTO 0 );
      clock   : IN     std_ulogic;
      dataIn  : IN     signed ( registerBitNb-1 DOWNTO 0 );
      reset   : IN     std_ulogic;
      write   : IN     std_ulogic;
      dataOut : OUT    signed ( registerBitNb-1 DOWNTO 0 )
   );

END scratchpad;
