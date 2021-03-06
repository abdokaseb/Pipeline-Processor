Library IEEE;
use ieee.std_logic_1164.all;
use work.constants.all;

-- FetchStage Entity

ENTITY FetchStage IS
    Generic(addressBits: integer := 5;
            wordSize: integer :=16;
            PCSize: integer :=PCLength);
	PORT(
            PCReg: in STD_LOGIC_VECTOR(PCSize-1 DOWNTO 0);
			clk: in STD_LOGIC;
            IFIDBuffer: out STD_LOGIC_VECTOR(IFIDLength DOWNTO 0)
		);

END ENTITY FetchStage;

----------------------------------------------------------------------
-- FetchStageister Architecture

ARCHITECTURE FetchStageArch of FetchStage is

    signal dummyDatain : STD_LOGIC_VECTOR(wordSize - 1 DOWNTO 0); 
BEGIN

    CodeRamEnt : entity work.ram generic map(RAMaddressBits,wordSize) port map(
        clk => clk,
        we => '0',
        rd => '1',
        twoWords => '1',
        address => PCReg(RAMaddressBits - 1 DOWNTO 0),
        datain1 => dummyDatain,
        datain2 => dummyDatain,
        dataout1 => IFIDBuffer(IFIDInstruction1E downto IFIDInstruction1S),
        dataout2 => IFIDBuffer(IFIDInstruction2E downto IFIDInstruction2S)
    );
    
    IFIDBuffer(IFIDPCE downto IFIDPCS) <= PCReg;


END ARCHITECTURE;