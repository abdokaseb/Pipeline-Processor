Library IEEE;
use ieee.std_logic_1164.all;
use work.constants.all;

-- InstructionConvert Entity

ENTITY InstructionConvert IS
	PORT(
			Instruction: in STD_LOGIC_VECTOR(IFIDInstruction1E DOWNTO IFIDInstruction1S);
            MR, MW, WB, StackOperation, OutOp, BranchOrNot, IsALUOper : out STD_LOGIC;
            OperationCode : out STD_LOGIC_VECTOR(3 downto 0);
            isIN, isLDM: out STD_LOGIC
		);

END ENTITY InstructionConvert;

----------------------------------------------------------------------
-- InstructionConvert Architecture

ARCHITECTURE InstructionConvertArch of InstructionConvert is

    signal typePartFromIns, typePart : STD_LOGIC_VECTOR(1 downto 0);
    signal instructPartFromIns, instructPart : STD_LOGIC_VECTOR(2 downto 0);
BEGIN



    typePartFromIns <= Instruction(IFIDInstructionType1E downto IFIDInstructionType1S);
    instructPartFromIns <= Instruction(IFIDInstructionOpCode1E downto IFIDInstructionOpCode1S);

    typePart <= twoOperandInstruction when (typePartFromIns = oneOperandInstruction and instructPartFromIns = OpCodeIN)
                or (typePartFromIns = MemoryInstruction and instructPartFromIns = OpCodeLDM)
                else typePartFromIns;
    instructPart <= OpCodeMOV when (typePartFromIns = oneOperandInstruction and instructPartFromIns = OpCodeIN)
                or (typePartFromIns = MemoryInstruction and instructPartFromIns = OpCodeLDM)
                else instructPartFromIns;

    isIN <= '1' when (typePartFromIns = oneOperandInstruction and instructPartFromIns = OpCodeIN)
            else '0';

    isLDM <= '1' when (typePartFromIns = MemoryInstruction and instructPartFromIns = OpCodeLDM)
            else '0';
            
    MR <= '1' when (instructPart = OpCodePOP and typePart = MemoryInstruction)
                or (instructPart =  OpCodeSTD and typePart = MemoryInstruction)
                or (instructPart =  OpCodeRET and typePart = branchInstruction)
                or (instructPart =  OpCodeRTI and typePart = branchInstruction)
            else '0';
                
                
    MW <= '1' when (instructPart = OpCodePUSH and typePart = MemoryInstruction)
                or (instructPart =  OpCodeLDD and typePart = MemoryInstruction)
                or (instructPart =  OpCodeCALL and typePart = branchInstruction)
            else '0';
    
    WB <= '1' when (instructPart = OpCodePOP and typePart = MemoryInstruction)
            or (instructPart =  OpCodeLDM and typePart = MemoryInstruction)
            or (instructPart =  OpCodeSTD and typePart = MemoryInstruction)
            or typePart = twoOperandInstruction
            or (instructPart =  OpCodeNOT and typePart = oneOperandInstruction)
            or (instructPart =  OpCodeINC and typePart = oneOperandInstruction)
            or (instructPart =  OpCodeDEC and typePart = oneOperandInstruction)
            or (instructPart =  OpCodeIN and typePart = oneOperandInstruction)
        else '0';

    StackOperation <= '1' when (instructPart = OpCodePOP and typePart = MemoryInstruction)
            or (instructPart =  OpCodePUSH and typePart = MemoryInstruction)
        else '0';

    OutOp <= '1' when (instructPart = OpCodeOUT and typePart = oneOperandInstruction)
        else '0';
    
    BranchOrNot <= '1' when typePart = branchInstruction and (
               instructPart = OpCodeJZ or instructPart = OpCodeJN 
            or instructPart = OpCodeJC or instructPart = OpCodeJMP 
            or instructPart = OpCodeCALL)
        else '0';
    
    IsALUOper <= '1' when typePart = twoOperandInstruction 
            or (typePart = oneOperandInstruction and not (instructPart = OpCodeOUT or instructPart = OpCodeIN))
        else '0';

    
    OperationCode <= 
             OperationMOV    when typePart = twoOperandInstruction    and instructPart = OpCodeMOV
        else OperationADD    when typePart = twoOperandInstruction    and instructPart = OpCodeADD
        else OperationSUB    when typePart = twoOperandInstruction    and instructPart = OpCodeSUB
        else OperationAND    when typePart = twoOperandInstruction    and instructPart = OpCodeAND
        else OperationOR     when typePart = twoOperandInstruction    and instructPart = OpCodeOR
        else OperationSHL    when typePart = twoOperandInstruction    and instructPart = OpCodeSHL
        else OperationSHR    when typePart = twoOperandInstruction    and instructPart = OpCodeSHR
        else OperationSETC   when typePart = oneOperandInstruction    and instructPart = OpCodeSETC
        else OperationCLRC   when typePart = oneOperandInstruction    and instructPart = OpCodeCLRC
        else OperationNOT    when typePart = oneOperandInstruction    and instructPart = OpCodeNOT
        else OperationINC    when typePart = oneOperandInstruction    and instructPart = OpCodeINC
        else OperationDEC    when typePart = oneOperandInstruction    and instructPart = OpCodeDEC
        else OperationJZ     when typePart = branchInstruction        and instructPart = OpCodeJZ
        else OperationJN     when typePart = branchInstruction        and instructPart = OpCodeJN
        else OperationJC     when typePart = branchInstruction        and instructPart = OpCodeJC
        else OperationJMP    when typePart = branchInstruction        and instructPart = OpCodeJMP
        else OperationCALL   when typePart = branchInstruction        and instructPart = OpCodeCALL
        else OperationRET    when typePart = branchInstruction        and instructPart = OpCodeRET
        else OperationRTI    when typePart = branchInstruction        and instructPart = OpCodeRTI
        else OperationNOP   ;
        

END ARCHITECTURE;