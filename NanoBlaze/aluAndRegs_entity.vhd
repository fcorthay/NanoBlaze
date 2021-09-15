LIBRARY ieee;
  USE ieee.std_logic_1164.all;
  USE ieee.numeric_std.all;

ENTITY aluAndRegs IS
   GENERIC( 
      registerBitNb          : positive := 8;
      registerAddressBitNb   : positive := 4;
      aluCodeBitNb           : positive := 5;
      portAddressBitNb       : positive := 8;
      scratchpadAddressBitNb : natural  := 4
   );
   PORT( 
      addrA           : IN     unsigned ( registerAddressBitNb-1 DOWNTO 0 );
      addrB           : IN     unsigned ( registerAddressBitNb-1 DOWNTO 0 );
      aluCode         : IN     std_ulogic_vector ( aluCodeBitNb-1 DOWNTO 0 );
      cIn             : IN     std_ulogic;
      clock           : IN     std_ulogic;
      instrData       : IN     signed ( registerBitNb-1 DOWNTO 0 );
      instrDataSel    : IN     std_ulogic;
      portIn          : IN     signed ( registerBitNb-1 DOWNTO 0 );
      portInSel       : IN     std_ulogic;
      regWrite        : IN     std_ulogic;
      registerFileSel : IN     std_ulogic;
      reset           : IN     std_ulogic;
      scratchpadSel   : IN     std_ulogic;
      spadIn          : IN     signed ( registerBitNb-1 DOWNTO 0 );
      cOut            : OUT    std_ulogic;
      portAddr        : OUT    unsigned (portAddressBitNb-1 DOWNTO 0);
      portOut         : OUT    signed ( registerBitNb-1 DOWNTO 0 );
      scratchpadAddr  : OUT    unsigned (scratchpadAddressBitNb-1 DOWNTO 0);
      spadOut         : OUT    signed ( registerBitNb-1 DOWNTO 0 );
      zero            : OUT    std_ulogic
   );

END aluAndRegs;
