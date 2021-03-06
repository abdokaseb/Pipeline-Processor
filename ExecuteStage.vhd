Library IEEE;
use ieee.std_logic_1164.all;
use work.constants.all;

-- ExecuteStage Entity

ENTITY ExecuteStage IS
    Generic(wordSize:integer :=16);
	PORT(
            IDEXBuffer: in STD_LOGIC_VECTOR(IDEXLength downto 0);
            EXMEMBuffer: in STD_LOGIC_VECTOR(EXMEMLength downto 0);
            MEMWBBuffer: in STD_LOGIC_VECTOR(MEMWBLength downto 0);
            FlagsWBFromMEM:in STD_LOGIC;
            FlagsFromMEM:in STD_LOGIC_VECTOR (flagsCount-1 downto 0);
            clk, rst,keepFlushing: in STD_LOGIC;
            EXMEMbufferOut: out STD_LOGIC_VECTOR(EXMEMLength downto 0);
            IFIDflushVector , IDEXflushVector, EXMEMflushVector: out STD_LOGIC_VECTOR(0 TO 2);   
            PCFromEX:out STD_LOGIC_VECTOR (31 downto 0);     
            PCWBFromEX:out STD_LOGIC;
            OutOfOutInstr: out STD_LOGIC_VECTOR (15 downto 0)   
        );

END ENTITY ExecuteStage;

----------------------------------------------------------------------
-- ExecuteStage Architecture

ARCHITECTURE ExecuteStageArch of ExecuteStage is

    Signal ALUsrc1,ALUdst1,ALUsrc2,ALUdst2: std_logic_vector(wordSize-1 downto 0);
    SIGNAL FlagsToALU1,FlagsToALU2,FlagsFromALU1,FlagsFromALU2,FlagsToMem,BranchExeFlags1,BranchExeFlags2 : STD_LOGIC_VECTOR(flagsCount-1 downto 0);
BEGIN

    ForwardUnitEnt: entity work.ForwardUnit port map(
        IDEXBuffer,
        EXMEMBuffer,
        MEMWBBuffer,
        ALUsrc1,
        ALUdst1,
        ALUsrc2,
        ALUdst2);

    MemorySelectionUnitEnt: entity work.MemorySelectionUnit port map(
        IDEXBuffer,
        EXMEMbufferOut,
        ALUsrc1,
        ALUdst1,
        ALUsrc2,
        ALUdst2);


    ALU1Ent : entity work.alu port map(
        A => ALUsrc1,
        B => ALUdst1,
        F => EXMEMbufferOut(EXMEMResult1E downto EXMEMResult1S),
        shiftAm => IDEXBuffer(IDEXShiftAmount1E downto IDEXShiftAmount1S),
        operationControl => IDEXBuffer(IDEXOperationCode1E downto IDEXOperationCode1S),
        flagIn => FlagsToALU1,
        flagOut => FlagsFromALU1
    );

    ALU2Ent : entity work.alu port map(
        A => ALUsrc2,
        B => ALUdst2,
        F => EXMEMbufferOut(EXMEMResult2E downto EXMEMResult2S),
        shiftAm => IDEXBuffer(IDEXShiftAmount2E downto IDEXShiftAmount2S),
        operationControl => IDEXBuffer(IDEXOperationCode2E downto IDEXOperationCode2S),
        flagIn => FlagsToALU2,
        flagOut => FlagsFromALU2
    );

    ---------------------------------- FLAGS CIRCUIT -----------------------------
    FlagsUnitEnt: entity work.FlagsUnit port map(
        FlagsFromALU1 => FlagsFromALU1,
        FlagsFromALU2 => FlagsFromALU2,
        FlagsFromMem => FlagsFromMEM,
        FlagsWBFromMEM => FlagsWBFromMEM,
        IsALUOper1 => IDEXBuffer(IDEXIsALUOper1),
        IsALUOper2 => IDEXBuffer(IDEXIsALUOper2),
        FlagsToALU1 => FlagsToALU1,
        FlagsToALU2 => FlagsToALU2,
        FlagsToMem => FlagsToMem,
        BranchExeFlags1 => BranchExeFlags1,
        BranchExeFlags2 => BranchExeFlags2,
        clk=>clk,
        rst=>rst,
        Buff2Flush => EXMEMflushVector(1) ------------------- flushing second buffer
    );

    --------- BranchAndControHazardsUnit -------------
    ControHazardsUnit: entity work.ControlHazardsUnit  port map(
        IDEXbuffer => IDEXBuffer,
        Rdst1FRWval => ALUdst1,
        Rdst2FRWval => ALUdst2,
        IFIDflushVector => IFIDflushVector, 
        IDEXflushVector => IDEXflushVector,
        EXMEMflushVector => EXMEMflushVector,
        keepFlushing => keepFlushing,
        PCFromEX => PCFromEX,
        PCWBFromEX => PCWBFromEX,
        FlagsToALU1 => FlagsToALU1,
        FlagsToALU2 => FlagsToALU2,
        BranchExeFlags1 => BranchExeFlags1,
        BranchExeFlags2 => BranchExeFlags2,
        EXMEMbufferOut => EXMEMbufferOut -- to put DSB
    );

    --------- OutInstrUnit ---------------
    OutInstrUnit: entity work.OutInstrUnit  port map(
        Rdst1FRWval => ALUdst1,
        Rdst2FRWval => ALUdst2,
        isOut1 => IDEXBuffer(IDEXOut1), 
        isOut2 => IDEXBuffer(IDEXOut2),
        Buff2Flush => EXMEMflushVector(1),
        OutOfOut => OutOfOutInstr
    );


    ------------- Just passed Signals ------------------------
    EXMEMbufferOut(EXMEMWB1) <= IDEXBuffer(IDEXWB1);
    EXMEMbufferOut(EXMEMWB2) <= IDEXBuffer(IDEXWB2);
    EXMEMbufferOut(EXMEMRdst1E downto EXMEMRdst1S) <= IDEXbuffer(IDEXRdst1E downto IDEXRdst1S);
    EXMEMbufferOut(EXMEMRdst2E downto EXMEMRdst2S) <= IDEXbuffer(IDEXRdst2E downto IDEXRdst2S);
    EXMEMbufferOut(EXMEMPCE downto EXMEMPCS) <= IDEXbuffer(IDEXPCE downto IDEXPCS);
    EXMEMbufferOut(EXMEMISINT) <= IDEXbuffer(IDEXISINT);
    EXMEMbufferOut(EXMEMFLAGSE downto EXMEMFLAGSS) <= FlagsToMem;

    -- not use signals
    EXMEMbufferOut(EXMEMWriteTwowordsS) <= '0'; -- noteused
    EXMEMbufferOut(EXMEMInc1E downto EXMEMFreeInc1S) <= (others => '0');
    EXMEMbufferOut(EXMEMInc2E downto EXMEMFreeInc2S) <= (others => '0');

    

END ARCHITECTURE;