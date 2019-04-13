Library IEEE;
use ieee.std_logic_1164.all;
use work.constants.all;

-- MemorySelectionUnit Entity

ENTITY MemorySelectionUnit IS
	PORT(
            IDEXBuffer: in STD_LOGIC_VECTOR(IDEXLength DOWNTO 0);
            EXMEMBuffer: out STD_LOGIC_VECTOR(EXMEMLength DOWNTO 0)
		);

END ENTITY MemorySelectionUnit;

----------------------------------------------------------------------
-- MemorySelectionUnitister Architecture

ARCHITECTURE MemorySelectionUnitArch of MemorySelectionUnit is

BEGIN



END ARCHITECTURE;