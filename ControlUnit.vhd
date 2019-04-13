Library IEEE;
use ieee.std_logic_1164.all;
use work.constants.all;

-- ControlUnit Entity

ENTITY ControlUnit IS
	PORT(
			Instruction1,Instruction2: in STD_LOGIC_VECTOR(IFIDInstruction1E DOWNTO 0);
            IDEXBuffer: out STD_LOGIC_VECTOR(IDEXLength DOWNTO 0)
		);

END ENTITY ControlUnit;

----------------------------------------------------------------------
-- ControlUnit Architecture

ARCHITECTURE ControlUnitArch of ControlUnit is

BEGIN


END ARCHITECTURE;