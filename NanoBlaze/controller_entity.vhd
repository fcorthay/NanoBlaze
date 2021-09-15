LIBRARY ieee;
  USE ieee.std_logic_1164.all;
  USE ieee.numeric_std.all;

ENTITY controller IS
   GENERIC( 
      intCodeBitNb    : positive := 5;
      branchCondBitNb : positive := 3;
      opCodeBitNb     : positive := 5
   );
   PORT( 
      branchCond       : IN     std_ulogic_vector ( branchCondBitNb-1 DOWNTO 0 );
      cOut             : IN     std_ulogic;
      clock            : IN     std_ulogic;
      en               : IN     std_ulogic;
      int              : IN     std_uLogic;
      intCode          : IN     std_ulogic_vector ( intCodeBitNb-1 DOWNTO 0 );
      opCode           : IN     std_ulogic_vector (opCodeBitNb-1 DOWNTO 0);
      reset            : IN     std_ulogic;
      twoRegInstr      : IN     std_ulogic;
      zero             : IN     std_ulogic;
      cIn              : OUT    std_ulogic;
      incPC            : OUT    std_ulogic;
      instrDataSel     : OUT    std_ulogic;
      intAck           : OUT    std_ulogic;
      loadInstrAddress : OUT    std_ulogic;
      loadStoredPC     : OUT    std_ulogic;
      portInSel        : OUT    std_ulogic;
      prevPC           : OUT    std_ulogic;
      readStrobe       : OUT    std_uLogic;
      regWrite         : OUT    std_ulogic;
      registerFileSel  : OUT    std_ulogic;
      scratchpadSel    : OUT    std_ulogic;
      scratchpadWrite  : OUT    std_ulogic;
      storePC          : OUT    std_ulogic;
      writeStrobe      : OUT    std_uLogic
   );

END controller;
