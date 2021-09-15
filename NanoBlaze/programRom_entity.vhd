LIBRARY ieee;
  USE ieee.std_logic_1164.all;
  USE ieee.numeric_std.all;

ENTITY programRom IS
   GENERIC( 
      addressBitNb : positive := 8;
      dataBitNb    : positive := 8
   );
   PORT( 
      address : IN     unsigned (addressBitNb-1 DOWNTO 0);
      clock   : IN     std_ulogic;
      en      : IN     std_ulogic;
      reset   : IN     std_ulogic;
      dataOut : OUT    std_ulogic_vector ( dataBitNb-1 DOWNTO 0 )
   );

END programRom;
