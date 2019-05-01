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
    signal PCFromMEMStage,PCFromEXStage : STD_LOGIC_VECTOR(PCLength-1 DOWNTO 0);  
    signal PCWBFromMEMStage,PCWBFromEXStage: STD_LOGIC; 
    Signal pcIncrementControl : STD_LOGIC_VECTOR(1 downto 0);

    -- Flush Vectors (0) first(upper)buffer ,(1) second(lower)buffer ,(2) third(common)buffer 
    signal IFIDflushVector: STD_LOGIC_VECTOR(0 TO 2);
    signal IDEXflushVector: STD_LOGIC_VECTOR(0 TO 2);
    signal EXMEMflushVector: STD_LOGIC_VECTOR(0 TO 2);
    signal keepFlushing: STD_LOGIC;

    -- Int is done signal
    signal finishInt :STD_LOGIC;
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
        ExPcEnable => PCWBFromEXStage,
        ExPC => PCFromEXStage,
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

    IFIDRegEnt: entity work.BuffwithFlushGen generic map(IFID,IFIDLength+1) port map(IFIDBufferD,IFIDen,clk,IFIDrst,IFIDBufferQ,IFIDflushVector);

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

    IDEXRegEnt: entity work.BuffwithFlushGen generic map(IDEX,IDEXLength+1) port map(IDEXBufferD,IDEXen,clk,IDEXrst,IDEXBufferQ,IDEXflushVector);

    ExecuteStageEnt: entity work.ExecuteStage generic map(wordSize) port map(
        IDEXBuffer => IDEXBufferQ,
        EXMEMBuffer => EXMEMBufferQ,
        MEMWBBuffer => MEMWBBufferQ,
        FlagsFromMEM => FlagsFromMEMtoEXE,
        FlagsWBFromMEM => FlagsWBFromMEMtoEXE, 
        PCWBFromEX => PCWBFromEXStage,
        PCFromEX => PCFromEXStage,
        clk => clk,
        rst => rst,
        EXMEMbufferOut => EXMEMbufferD,
        keepFlushing => keepFlushing,
        IFIDflushVector => IFIDflushVector,
        IDEXflushVector => IDEXflushVector, 
        EXMEMflushVector => EXMEMflushVector,
        OutOfOutInstr => OutPort
    );

    EXMEMRegEnt: entity work.BuffwithFlushGen generic map(EXMEM,EXMEMLength+1) port map(EXMEMBufferD,EXMEMen,clk,EXMEMrst,EXMEMBufferQ,EXMEMflushVector);

    MemoryStageEnt: entity work.MemoryStage port map(
        EXMEMbuffer => EXMEMbufferQ,
        FlagsOut => FlagsFromMEMtoEXE, 
        FlagsWBout => FlagsWBFromMEMtoEXE,
        currentPC => PCReg,
        PCout => PCFromMEMStage ,
        PCWBout => PCWBFromMEMStage,
        RESET => resetSignal,
        clk => clk,
        rst => rst,
        MEMWBbuffer => MEMWBbufferD,
        keepFlushing => keepFlushing, -- nccessary for state machines RTI ,INT 
        finishInt => finishInt  -- nccessary for telling control unit thant int operations are done to start moving pc again
    );

    MEMWBRegEnt: entity work.Reg generic map(MEMWBLength+1) port map(MEMWBBufferD,MEMWBen,clk,MEMWBrst,MEMWBBufferQ);


END ARCHITECTURE;