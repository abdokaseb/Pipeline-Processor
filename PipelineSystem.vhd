Library IEEE;
use ieee.std_logic_1164.all;
use work.constants.all;

-- PipelineSystem Entity

ENTITY PipelineSystem IS
    Generic(PCSize: integer :=PCLength;
            wordsize: integer :=16;
            addressSize: integer :=5
    );
	PORT(
            clk, rst, interruptSignal, resetSignal: in STD_LOGIC;
            INPort: in STD_LOGIC_VECTOR(wordsize-1 DOWNTO 0);
            OutPort: out STD_LOGIC_VECTOR(wordsize-1 DOWNTO 0)
		);

END ENTITY PipelineSystem;

----------------------------------------------------------------------
-- PipelineSystemister Architecture

ARCHITECTURE PipelineSystemArch of PipelineSystem is
    signal IFIDBufferD,IFIDBufferQ: STD_LOGIC_VECTOR(IFIDLength DOWNTO 0);
    signal IDEXBufferD,IDEXBufferQ: STD_LOGIC_VECTOR(IDEXLength DOWNTO 0);
    signal EXMEMbufferD,EXMEMbufferQ: STD_LOGIC_VECTOR(EXMEMLength DOWNTO 0);
    signal MEMWBbufferD, MEMWBbufferQ: STD_LOGIC_VECTOR(MEMWBLength DOWNTO 0);

    signal PCReg: STD_LOGIC_VECTOR(PCSize-1 DOWNTO 0);
    signal IFIDen, IFIDrst, IDEXen, IDEXrst, EXMEMen, EXMEMrst, MEMWBen, MEMWBrst: STD_LOGIC;

-------- INTER STAGES COMMUNICATION ------------
    signal FlagsFromMEMtoEXE : STD_LOGIC_VECTOR(flagsCount-1 DOWNTO 0);  
    signal FlagsWBFromMEMtoEXE : STD_LOGIC; 
    signal PCFromMEMStage : STD_LOGIC_VECTOR(PCLength-1 DOWNTO 0);  
    signal PCWBFromMEMStage: STD_LOGIC; 
    Signal pcIncrementControl : STD_LOGIC_VECTOR(1 downto 0);
BEGIN

    IFIDen <= '1';
    IFIDrst <= '0' or rst;
    IDEXen <= '1';
    IDEXrst <= '0' or rst;
    EXMEMen <= '1';
    EXMEMrst <= '0' or rst;
    MEMWBen <= '1';
    MEMWBrst <= '0' or rst;


    PCControlUnitEnt: entity work.PCControlUnit generic map(PCSize) port map(
        clk => clk,
        reset =>rst,
        ExPcEnable => '0',  ------ hardcoded --- signlal not found in EX stage 
        ExPC => (others =>'0'),--- hardcode ---- not found in excution stage
        MemPcEnable => PCWBFromMEMStage, 
        MemPc=>PCFromMEMStage,
        ControlPCoperation=> pcIncrementControl,
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
        beforeIFIDbuffer => IFIDBufferD,
        MEMWBbuffer => MEMWBbufferQ,
        INPort => INPort,
        clk => clk,
        rst => rst,
        interruptSignal => interruptSignal, 
        resetSignal => resetSignal,
        IDEXBuffer => IDEXBufferD,
        PcIncrement=> pcIncrementControl
    );

    IDEXRegEnt: entity work.Reg generic map(IDEXLength+1) port map(IDEXBufferD,IDEXen,clk,IDEXrst,IDEXBufferQ);

    ExecuteStageEnt: entity work.ExecuteStage generic map(wordSize) port map(
        IDEXBuffer => IDEXBufferQ,
        EXMEMBuffer => EXMEMBufferQ,
        MEMWBBuffer => MEMWBBufferQ,
        FlagsFromMEM => FlagsFromMEMtoEXE,
        FlagsWBFromMEM => FlagsWBFromMEMtoEXE, 
        clk => clk,
        rst => rst,
        EXMEMbufferOut => EXMEMbufferD
    );

    EXMEMRegEnt: entity work.Reg generic map(EXMEMLength+1) port map(EXMEMBufferD,EXMEMen,clk,EXMEMrst,EXMEMBufferQ);

    MemoryStageEnt: entity work.MemoryStage port map(
        EXMEMbuffer => EXMEMbufferQ,
        FlagsOut => FlagsFromMEMtoEXE, 
        FlagsWBout => FlagsWBFromMEMtoEXE,
        PCout => PCFromMEMStage ,
        PCWBout => PCWBFromMEMStage,
        clk => clk,
        rst => rst,
        -- MemOut => MemOut,
        MEMWBbuffer => MEMWBbufferD
    );

    MEMWBRegEnt: entity work.Reg generic map(MEMWBLength+1) port map(MEMWBBufferD,MEMWBen,clk,MEMWBrst,MEMWBBufferQ);


END ARCHITECTURE;