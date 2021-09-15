ARCHITECTURE RTL OF instructionDecoder IS

  constant opCodeIndexH         : integer := instruction'high;
  constant opCodeIndexL         : integer := opCodeIndexH - opCodeBitNb + 1;

  constant twoRegInstrIndex     : integer := opCodeIndexL - 1;
  constant ioAddrIndexed        : integer := twoRegInstrIndex;

  constant addrAIndexH          : integer := twoRegInstrIndex - 1;
  constant addrAIndexL          : integer := addrAIndexH - registerAddressBitNb + 1;

  constant immediateDataIndexH  : integer := registerBitNb-1;
  constant immediateDataIndexL  : integer := 0;
  constant addrBIndexH          : integer := addrAIndexL - 1;
  constant addrBIndexL          : integer := addrBIndexH - registerAddressBitNb + 1;

  constant aluCodeIndexH        : integer := opCodeIndexH;
  constant aluCodeIndexL        : integer := aluCodeIndexH - aluCodeBitNb + 1;

  constant portAddressH         : integer := registerBitNb-1;
  constant portAddressL         : integer := portAddressH-portAddressBitNb+1;
  constant spadAddressH         : integer := registerBitNb-1;
  constant spadAddressL         : integer := spadAddressH-spadAddressBitNb+1;

  constant branchCondH          : integer := opCodeIndexL-1;
  constant branchCondL          : integer := branchCondH-branchCondBitNb+1;

BEGIN
  ------------------------------------------------------------------------------
                                                                  -- ALU control
  aluCode <=
    instruction(aluCodeIndexH downto aluCodeIndexL)
      when instruction(aluCodeIndexH) = '0' else
    '1' & instruction(aluCodeBitNb-2 downto 0);
  opCode <= instruction(opCodeIndexH downto opCodeIndexL);
  twoRegInstr <= instruction(twoRegInstrIndex);
  addrA <= unsigned(instruction(addrAIndexH downto addrAIndexL));
  addrB <= unsigned(instruction(addrBIndexH downto addrBIndexL));
  instrData <= signed(instruction(immediateDataIndexH downto immediateDataIndexL));

  ------------------------------------------------------------------------------
                                                                  -- I/O control
  portIndexedSel <= instruction(ioAddrIndexed);
  portAddress <= unsigned(instruction(portAddressH downto portAddressL));

  ------------------------------------------------------------------------------
                                                           -- scratchpad control
  spadIndexedSel <= instruction(ioAddrIndexed);
  spadAddress <= unsigned(instruction(spadAddressH downto spadAddressL));

  ------------------------------------------------------------------------------
                                                               -- branch control
  branchCond <= instruction(branchCondH downto branchCondL);
  instrAddress <= unsigned(instruction(instrAddress'range));

END ARCHITECTURE RTL;
