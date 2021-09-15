LIBRARY ieee;
  USE ieee.std_logic_1164.all;
  USE ieee.numeric_std.all;

ENTITY instructionDecoder IS
   GENERIC( 
      registerBitNb        : positive := 8;
      registerAddressBitNb : positive := 4;
      aluCodeBitNb         : positive := 5;
      instructionBitNb     : positive := 18;
      programCounterBitNb  : positive := 10;
      opCodeBitNb          : positive := 5;
      branchCondBitNb      : positive := 3;
      intCodeBitNb         : positive := 5;
      spadAddressBitNb     : natural  := 4;
      portAddressBitNb     : positive := 8
   );
   PORT( 
      instruction    : IN     std_ulogic_vector ( instructionBitNb-1 DOWNTO 0 );
      addrA          : OUT    unsigned ( registerAddressBitNb-1 DOWNTO 0 );
      addrB          : OUT    unsigned ( registerAddressBitNb-1 DOWNTO 0 );
      aluCode        : OUT    std_ulogic_vector ( aluCodeBitNb-1 DOWNTO 0 );
      branchCond     : OUT    std_ulogic_vector (branchCondBitNb-1 DOWNTO 0);
      instrAddress   : OUT    unsigned ( programCounterBitNb-1 DOWNTO 0 );
      instrData      : OUT    signed ( registerBitNb-1 DOWNTO 0 );
      intCode        : OUT    std_ulogic_vector ( intCodeBitNb-1 DOWNTO 0 );
      opCode         : OUT    std_ulogic_vector ( opCodeBitNb-1 DOWNTO 0 );
      portAddress    : OUT    unsigned (portAddressBitNb-1 DOWNTO 0);
      portIndexedSel : OUT    std_ulogic;
      spadAddress    : OUT    unsigned ( spadAddressBitNb-1 DOWNTO 0 );
      spadIndexedSel : OUT    std_ulogic;
      twoRegInstr    : OUT    std_ulogic
   );

END instructionDecoder;
