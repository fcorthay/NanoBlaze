LIBRARY ieee;
  USE ieee.std_logic_1164.all;
  USE ieee.numeric_std.all;

ENTITY aluBOpSelector IS
   GENERIC( 
      registerBitNb : positive := 8
   );
   PORT( 
      instrData       : IN     signed ( registerBitNb-1 DOWNTO 0 );
      instrDataSel    : IN     std_ulogic;
      portIn          : IN     signed ( registerBitNb-1 DOWNTO 0 );
      portInSel       : IN     std_ulogic;
      registerFileIn  : IN     signed ( registerBitNb-1 DOWNTO 0 );
      registerFileSel : IN     std_ulogic;
      scratchpadSel   : IN     std_ulogic;
      spadIn          : IN     signed ( registerBitNb-1 DOWNTO 0 );
      opB             : OUT    signed (registerBitNb-1 DOWNTO 0)
   );

END aluBOpSelector;
