Library IEEE;
use ieee.std_logic_1164.all;
use work.constants.all;

-- ExecuteStage Entity

ENTITY ExecuteStage IS
    Generic(wordSize:integer :=16);
	PORT(
            IDEXBuffer: in STD_LOGIC_VECTOR(IDEXLength DOWNTO 0);
            EXMEMBuffer: in STD_LOGIC_VECTOR(EXMEMLength DOWNTO 0);
            MEMWBBuffer: in STD_LOGIC_VECTOR(MEMWBLength DOWNTO 0);
            clk, rst: in STD_LOGIC;
            EXMEMbufferOut: out STD_LOGIC_VECTOR(EXMEMLength DOWNTO 0)
		);

END ENTITY ExecuteStage;

----------------------------------------------------------------------
-- ExecuteStage Architecture

ARCHITECTURE ExecuteStageArch of ExecuteStage is

    Signal ALUsrc1,ALUdst1,ALUsrc2,ALUdst2: std_logic_vector(wordSize-1 downto 0);
    SIGNAL FlagsToALU1,FlagsToALU2,FlagsFromALU1,FlagsFromALU2 : STD_LOGIC_VECTOR(flagsCount-1 DOWNTO 0);
BEGIN

    ForwardUnitEnt: entity work.ForwardUnit port map(IDEXBuffer,EXMEMBuffer,MEMWBBuffer,ALUsrc1,ALUdst1,ALUsrc2,ALUdst2);

    --MemorySelectionUnitEnt: entity work.MemorySelectionUnit port map(IDEXBuffer,EXMEMbufferOut);


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
        FlagsFromMem => MEMWBBuffer(MEMWBFLAGSE downto MEMWBFLAGSS),
        ExMemDSB => EXMEMBuffer(EXMEMDSBE downto EXMEMDSBS),
        IsALUOper1 => IDEXBuffer(IDEXIsALUOper1),
        IsALUOper2 => IDEXBuffer(IDEXIsALUOper2),
        FlagsToALU1 => FlagsToALU1,
        FlagsToALU2 => FlagsToALU2,
        clk=>clk,
        rst=>rst,
        Buff2Flush =>'0' ------------------- TO BE CHANGED
    );


    EXMEMbufferOut(EXMEMWB1) <= IDEXBuffer(IDEXWB1);
    EXMEMbufferOut(EXMEMWB2) <= IDEXBuffer(IDEXWB2);
    EXMEMbufferOut(EXMEMRdst1E downto EXMEMRdst1S) <= IDEXbuffer(IDEXRdst1E downto IDEXRdst1S);
    EXMEMbufferOut(EXMEMRdst2E downto EXMEMRdst2S) <= IDEXbuffer(IDEXRdst2E downto IDEXRdst2S);
    EXMEMbufferOut(EXMEMPCE downto EXMEMPCS) <= IDEXbuffer(IDEXPCE downto IDEXPCS);
    

END ARCHITECTURE;