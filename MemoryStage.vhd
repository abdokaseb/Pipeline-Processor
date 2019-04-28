Library IEEE;
use ieee.std_logic_1164.all;
use work.constants.all;

-- MemoryStage Entity

ENTITY MemoryStage IS
	GENERIC (addressSize:INTEGER := RAMaddressBits;
						wordSize: integer :=16);
	PORT(
			EXMEMbuffer: in STD_LOGIC_VECTOR(EXMEMLength DOWNTO 0);
			clk, rst,RESET: in STD_LOGIC;
			MEMWBbuffer: out STD_LOGIC_VECTOR(MEMWBLength DOWNTO 0);
			FlagsOut : out  STD_LOGIC_VECTOR(flagsCount-1 DOWNTO 0);
			PCout : out  STD_LOGIC_VECTOR(PCLength-1 DOWNTO 0);
			FlagsWBout,PCWBout,keepFlushing : out  STD_LOGIC
        );

END ENTITY MemoryStage;

----------------------------------------------------------------------
-- MemoryStageister Architecture

ARCHITECTURE MemoryStageArch of MemoryStage IS
	SIGNAL address : STD_LOGIC_VECTOR(addressSize - 1 DOWNTO 0);
	SIGNAL dataMemIn1,dataMemIn2  : STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL dataMemOut1,dataMemOut2 : STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL MemRead,MemWrite,twoWordsReadOrWrite,PCWBPOPLD,FLAGSWBPOP: STD_LOGIC; 
BEGIN	
    MEMENTITY : ENTITY work.Ram generic map(addressSize,wordSize) PORT MAP(
        clk => clk,
        we => MemWrite,
        rd => MemRead,
        twoWords => twoWordsReadOrWrite,
        address => address,
		datain1 => dataMemIn1,
		datain2 => dataMemIn2,
		dataout1 => dataMemOut1,
		dataout2 => dataMemOut2
    );

    CALCMEMPARAMSENT : ENTITY work.CalcRamParamsUnit generic map(addressSize) PORT MAP(
		EXMEMbuffer => EXMEMbuffer,
		clk => clk,
        rst => rst,
        RESET => RESET,
        twoWordsReadOrWrite => twoWordsReadOrWrite,
        addressToMem => address,
		dataToMem1 => dataMemIn1,
		dataToMem2 => dataMemIn2,
		MemRead => MemRead,
		MemWrite => MemWrite,
		PCWBPOPLD => PCWBPOPLD,
        FLAGSWBPOP => FLAGSWBPOP,
        keepFlushing => keepFlushing
	); -- may add keep flushing for state mchanies and for call to flush stupid fetched instructions
	
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

    -- not used signals
    MEMWBbuffer(MEMWBInc1E downto MEMWBFreeInc1S) <= (others => '0');
    MEMWBbuffer(MEMWBInc2E downto MEMWBFreeInc2S) <= (others => '0');


END ARCHITECTURE;