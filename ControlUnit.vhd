Library IEEE;
use ieee.std_logic_1164.all;
use work.constants.all;

-- ControlUnit Entity

ENTITY ControlUnit IS
	PORT(
			Instruction1,Instruction2: in STD_LOGIC_VECTOR(IFIDInstruction1E DOWNTO 0);
            IDEXBuffer: out STD_LOGIC_VECTOR(IDEXLength DOWNTO 0)
		);

END ENTITY ControlUnit;

----------------------------------------------------------------------
-- ControlUnit Architecture

ARCHITECTURE ControlUnitArch of ControlUnit is
	signal MR1, MW1, WB1, StackOperation1, OutOp1, BranchOrNot1, IsALUOper1 : STD_LOGIC;
	signal OperationCode1 : STD_LOGIC_VECTOR(3 downto 0);
	signal MR2, MW2, WB2, StackOperation2, OutOp2, BranchOrNot2, IsALUOper2 : STD_LOGIC;
	signal OperationCode2 : STD_LOGIC_VECTOR(3 downto 0);
BEGIN

	InstructionConvert1Ent: entity work.InstructionConvert port map(
		Instruction1,
		MR1, MW1, WB1, StackOperation1, OutOp1, BranchOrNot1, IsALUOper1,
		OperationCode1
	);

	InstructionConvert2Ent: entity work.InstructionConvert port map(
		Instruction2,
		MR2, MW2, WB2, StackOperation2, OutOp2, BranchOrNot2, IsALUOper2,
		OperationCode2
	);

	IDEXBuffer(IDEXStackOperation1) <= StackOperation1;
	IDEXBuffer(IDEXShiftAmount1E downto IDEXShiftAmount1S) <= Instruction1(IFIDShiftAmount1E downto IFIDShiftAmount1S);
	IDEXBuffer(IDEXOperationCode1E downto IDEXOperationCode1S) <= OperationCode1;
	IDEXBuffer(IDEXOut1) <= OutOp1;
	IDEXBuffer(IDEXBranchOrNot1) <= BranchOrNot1;
	IDEXBuffer(IDEXIsALUOper1) <= IsALUOper1;

	IDEXBuffer(IDEXStackOperation2) <= StackOperation2;
	IDEXBuffer(IDEXShiftAmount2E downto IDEXShiftAmount2S) <= Instruction2(IFIDShiftAmount1E downto IFIDShiftAmount1S);
	IDEXBuffer(IDEXOperationCode2E downto IDEXOperationCode2S) <= OperationCode2;
	IDEXBuffer(IDEXOut2) <= OutOp2;
	IDEXBuffer(IDEXBranchOrNot2) <= BranchOrNot2;
	IDEXBuffer(IDEXIsALUOper2) <= IsALUOper2;

END ARCHITECTURE;