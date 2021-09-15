LIBRARY ieee;
  USE ieee.std_logic_1164.all;
  USE ieee.numeric_std.all;

ENTITY alu IS
   GENERIC( 
      aluCodeBitNb : positive := 5;
      dataBitNb    : positive := 8
   );
   PORT( 
      aluCode : IN     std_ulogic_vector ( aluCodeBitNb-1 DOWNTO 0 );
      cIn     : IN     std_ulogic;
      opA     : IN     signed ( dataBitNb-1 DOWNTO 0 );
      opB     : IN     signed ( dataBitNb-1 DOWNTO 0 );
      aluOut  : OUT    signed ( dataBitNb-1 DOWNTO 0 );
      cOut    : OUT    std_ulogic;
      zero    : OUT    std_ulogic
   );

END alu;
