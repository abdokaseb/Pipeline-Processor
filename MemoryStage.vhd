Library IEEE;
use ieee.std_logic_1164.all;
use work.constants.all;

-- MemoryStage Entity

ENTITY MemoryStage IS
	GENERIC (addressSize:INTEGER := 5);
	PORT(
			EXMEMbuffer: in STD_LOGIC_VECTOR(EXMEMLength DOWNTO 0);
			clk, rst: in STD_LOGIC;
			MEMWBbuffer: out STD_LOGIC_VECTOR(MEMWBLength DOWNTO 0);
			FlagsOut : out  STD_LOGIC_VECTOR(flagsCount-1 DOWNTO 0);
			PCout : out  STD_LOGIC_VECTOR(PCLength-1 DOWNTO 0);
			FlagsWBout,PCWBout : out  STD_LOGIC
		);

END ENTITY MemoryStage;

----------------------------------------------------------------------
-- MemoryStageister Architecture

ARCHITECTURE MemoryStageArch of MemoryStage IS
	SIGNAL address : STD_LOGIC_VECTOR(addressSize - 1 DOWNTO 0);
	SIGNAL dataMemIn1,dataMemIn2  : STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL dataMemOut1,dataMemOut2 : STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL MemRead,MemWrite,twoWordsWriteInMem,PCWBPOPLD,FLAGSWBPOP: STD_LOGIC; 
BEGIN	
    MEMENTITY : ENTITY work.Ram PORT MAP(
        clk => clk,
        we => MemWrite,
        twoWords => twoWordsWriteInMem,
        address => address,
		datain1 => dataMemIn1,
		datain2 => dataMemIn2,
		dataout1 => dataMemOut1,
		dataout2 => dataMemOut2
    );

    CALCMEMPARAMSENT : ENTITY work.CalcRamParamsUnit PORT MAP(
		EXMEMbuffer => EXMEMbuffer,
		clk => clk,
		rst => rst,
        twoWordsWriteInMem => twoWordsWriteInMem,
        addressToMem => address,
		dataToMem1 => dataMemIn1,
		dataToMem2 => dataMemIn2,
		MemRead => MemRead,
		MemWrite => MemWrite,
		PCWBPOPLD => PCWBPOPLD,
		FLAGSWBPOP => FLAGSWBPOP
	);
	
    MEMSTAGEOUTPUTENT : ENTITY work.MemStageOutput PORT MAP(
		EXMEMbuffer => EXMEMbuffer,
		dataFromMem1 => dataMemout1,
		dataFromMem2 => dataMemout2,
		MR => MemRead,
		PCWBPOPLD => PCWBPOPLD,
		FLAGSWBPOP => FLAGSWBPOP,
		FlagsOut => FlagsOut,
		PCout => PCout,
		PCWBout => PCWBout,
		FlagsWBout => FlagsWBout,
		MEMWBbuffer => MEMWBbuffer
    );



END ARCHITECTURE;