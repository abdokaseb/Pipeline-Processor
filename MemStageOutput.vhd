Library IEEE;
use ieee.std_logic_1164.all;
use work.constants.all;
use ieee.numeric_std.all;

-- MemStageOutput Entity

ENTITY MemStageOutput IS
	PORT(
		EXMEMbuffer: IN STD_LOGIC_VECTOR(EXMEMLength DOWNTO 0);
		dataFromMem1 , dataFromMem2 : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		MR,PCWBPOPLD,FLAGSWBPOP : IN STD_LOGIC;
		FlagsOut : out  STD_LOGIC_VECTOR(flagsCount-1 DOWNTO 0);
		PCout : out  STD_LOGIC_VECTOR(31 DOWNTO 0);
		FlagsWBout,PCWBout : out  STD_LOGIC;
		MEMWBbuffer: OUT STD_LOGIC_VECTOR(MEMWBLength DOWNTO 0)
	);

END ENTITY MemStageOutput;

----------------------------------------------------------------------
-- MemStageOutput Architecture

ARCHITECTURE MemStageOutputArch OF MemStageOutput IS
	SIGNAL ALUResult1, ALUResult2, WBVal1,WBVal2 : STD_LOGIC_VECTOR(15 DOWNTO 0);
BEGIN
	ALUResult1 <= EXMEMbuffer(EXMEMResult1E DOWNTO EXMEMResult1S);
	ALUResult2 <= EXMEMbuffer(EXMEMResult1E DOWNTO EXMEMResult1S);
	MEMWBbuffer(MEMWBWriteBackValue1E DOWNTO MEMWBWriteBackValue1S) <= WBVal1;
	MEMWBbuffer(MEMWBWriteBackValue2E DOWNTO MEMWBWriteBackValue2S) <= WBVal2;

	PCWBout <= PCWBPOPLD AND MR;
	FlagsWBout  <= FLAGSWBPOP AND MR;
	
	PCout <= dataFromMem1 & dataFromMem2 WHEN PCWBPOPLD ='1' AND MR = '1' ELSE (OTHERS => '0');
	FlagsOut <= dataFromMem1(flagsCount -1 DOWNTO 0) WHEN FLAGSWBPOP ='1' AND MR = '1' ELSE (OTHERS => '0');
	WBVal1 <= ALUResult1 WHEN MR = '0' ELSE dataFromMem1;
	WBVal2 <= ALUResult2 WHEN MR = '0' ELSE dataFromMem1;

	------------- Just PSSED VLAUES  FROM EXMEM TO MEMWB --------------
	MEMWBbuffer(MEMWBWB1) <= EXMEMbuffer(EXMEMWB2);
	MEMWBbuffer(MEMWBWB2) <= EXMEMbuffer(EXMEMWB2);
	MEMWBbuffer(MEMWBRdst1E DOWNTO MEMWBRdst1S) <= EXMEMbuffer(EXMEMRdst1E DOWNTO EXMEMRdst1S);
	MEMWBbuffer(MEMWBRdst2E DOWNTO MEMWBRdst2S) <= EXMEMbuffer(EXMEMRdst2E DOWNTO EXMEMRdst2S);
END ARCHITECTURE;