Library IEEE;
use ieee.std_logic_1164.all;
use work.constants.all;

-- PipelineSystem Entity

ENTITY PipelineSystem IS
    Generic(PCSize: integer :=32;
            wordsize: integer :=32;
            addressSize: integer :=5
    );
	PORT(
			clk, rst: in STD_LOGIC
		);

END ENTITY PipelineSystem;

----------------------------------------------------------------------
-- PipelineSystemister Architecture

ARCHITECTURE PipelineSystemArch of PipelineSystem is
    signal IFIDBufferD,IFIDBufferQ: STD_LOGIC_VECTOR(IFIDLength DOWNTO 0);
    signal IDEXBufferD,IDEXBufferQ: STD_LOGIC_VECTOR(IDEXLength DOWNTO 0);
    signal EXMEMbufferD,EXMEMbufferQ: STD_LOGIC_VECTOR(EXMEMLength DOWNTO 0);
    signal MEMWBbufferD, MEMWBbufferQ: STD_LOGIC_VECTOR(MEMWBLength DOWNTO 0);

    signal PCReg,MemOut : STD_LOGIC_VECTOR(PCSize-1 DOWNTO 0);  -- direct output from memory used for pop flags or pop pc
    signal IFIDen, IFIDrst, IDEXen, IDEXrst, EXMEMen, EXMEMrst, MEMWBen, MEMWBrst: STD_LOGIC;
    signal FlagsToMem : STD_LOGIC_VECTOR(flagCount-1 DOWNTO 0);  
BEGIN

    PCControlUnitEnt: entity work.PCControlUnit generic map(PCSize) port map(
        clk => clk,
        PCReg => PCReg
    );

    FetchStageEnt: entity work.FetchStage generic map(addressSize,wordsize,PCSize) port map(
        PCReg => PCreg,
        clk => clk,
        IFIDBuffer => IFIDBufferD
    );    

    IFIDRegEnt: entity work.Reg generic map(IFIDLength+1) port map(IFIDBufferD,IFIDen,clk,IFIDrst,IFIDBufferQ);

    DecodeStageEnt: entity work.DecodeStage port map(
        IFIDbuffer => IFIDBufferQ,
        MEMWBbuffer => MEMWBbufferQ,
        clk => clk,
        rst => rst,
        IDEXBuffer => IDEXBufferD
    );

    IDEXRegEnt: entity work.Reg generic map(IDEXLength+1) port map(IDEXBufferD,IDEXen,clk,IDEXrst,IDEXBufferQ);

    ExecuteStageEnt: entity work.ExecuteStage generic map(wordSize) port map(
        IDEXBuffer => IDEXBufferQ,
        EXMEMBuffer => EXMEMBufferQ,
        MEMWBBuffer => MEMWBBufferQ,
        clk => clk,
        rst => rst,
        EXMEMbufferOut => EXMEMbufferD
    );

    EXMEMRegEnt: entity work.Reg generic map(EXMEMLength+1) port map(EXMEMBufferD,EXMEMen,clk,EXMEMrst,EXMEMBufferQ);

    MemoryStageEnt: entity work.MemoryStage port map(
        EXMEMbuffer => EXMEMbufferQ,
        clk => clk,
        rst => rst,
        MemOut => MemOut,
        MEMWBbuffer => MEMWBbufferD
    );

    MEMWBRegEnt: entity work.Reg generic map(MEMWBLength+1) port map(MEMWBBufferD,MEMWBen,clk,MEMWBrst,MEMWBBufferQ);


END ARCHITECTURE;