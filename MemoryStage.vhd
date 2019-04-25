Library IEEE;
use ieee.std_logic_1164.all;
use work.constants.all;

-- MemoryStage Entity

ENTITY MemoryStage IS
	PORT(
			EXMEMbuffer: in STD_LOGIC_VECTOR(EXMEMLength DOWNTO 0);
			clk, rst: in STD_LOGIC;
			MEMWBbuffer: out STD_LOGIC_VECTOR(MEMWBLength DOWNTO 0);
			MemOut: out STD_LOGIC_VECTOR(31 DOWNTO 0) --direct output from ram use for pop pc and pop flags
		);

END ENTITY MemoryStage;

----------------------------------------------------------------------
-- MemoryStageister Architecture

ARCHITECTURE MemoryStageArch of MemoryStage is

BEGIN




END ARCHITECTURE;