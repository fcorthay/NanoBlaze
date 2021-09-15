LIBRARY ieee;
  USE ieee.std_logic_1164.all;
  USE ieee.numeric_std.all;

ENTITY registerFile IS
   GENERIC( 
      registerAddressBitNb : positive := 4;
      dataBitNb            : positive := 8
   );
   PORT( 
      addrA       : IN     unsigned ( registerAddressBitNb-1 DOWNTO 0 );
      addrB       : IN     unsigned ( registerAddressBitNb-1 DOWNTO 0 );
      clock       : IN     std_ulogic;
      regWrite    : IN     std_ulogic;
      registersIn : IN     signed ( dataBitNb-1 DOWNTO 0 );
      reset       : IN     std_ulogic;
      opA         : OUT    signed ( dataBitNb-1 DOWNTO 0 );
      opB         : OUT    signed ( dataBitNb-1 DOWNTO 0 )
   );

END registerFile;
