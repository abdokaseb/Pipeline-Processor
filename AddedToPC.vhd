Library IEEE;
use ieee.std_logic_1164.all;
use work.constants.all;

-- InstructionConvert Entity

ENTITY AddToPC IS
	PORT(
            IFIDBuffer: in STD_LOGIC_VECTOR(IFIDLength DOWNTO 0);
            clk,rst: in STD_LOGIC;
            addedToPC: out STD_LOGIC_VECTOR(1 downto 0)
		);

END ENTITY AddToPC;

----------------------------------------------------------------------


ARCHITECTURE AddToPCArch of AddToPC is
    signal currentInstruction1: STD_LOGIC_VECTOR(IFIDInstruction1E DOWNTO IFIDInstruction1S);
    signal currentInstruction2: STD_LOGIC_VECTOR(IFIDInstruction2E DOWNTO IFIDInstruction2S);
    signal nextInstruction1: STD_LOGIC_VECTOR(IFIDInstruction1E DOWNTO IFIDInstruction1S);
    signal nextInstruction2: STD_LOGIC_VECTOR(IFIDInstruction2E DOWNTO IFIDInstruction2S);

    signal typePartCurrentIns1,typePartCurrentIns2   : STD_LOGIC_VECTOR(1 downto 0);
    signal instructPartCurrentIns1, instructPartCurrentIns2 : STD_LOGIC_VECTOR(2 downto 0);
    signal typePartNextIns1,typePartNextIns2   : STD_LOGIC_VECTOR(1 downto 0);
    signal instructPartNextIns1, instructPartNextIns2 : STD_LOGIC_VECTOR(2 downto 0);
    
   -- signal typePartCurrentInst1,typePartCurrentInst2 : STD_LOGIC_VECTOR(1 downto 0);
    --signal instructPart : STD_LOGIC_VECTOR(2 downto 0);

    signal currentInstruction1dst :STD_LOGIC_VECTOR(2 downto 0);
    signal currentInstruction2src :STD_LOGIC_VECTOR(2 downto 0);
    signal currentInstruction2dst :STD_LOGIC_VECTOR(2 downto 0);
BEGIN

NextInst1: entity work.Reg generic map(16) port map(
    currentInstruction1,
		'1', clk, rst,nextInstruction1 
    );
NextInst2: entity work.Reg generic map(16) port map(
    currentInstruction2,
		'1', clk, rst,nextInstruction2 
    );
currentInstruction1 <= IFIDBuffer(IFIDInstruction1E downto IFIDInstruction1S);
currentInstruction2 <= IFIDBuffer(IFIDInstruction2E downto IFIDInstruction2S);

typePartCurrentIns1 <= currentInstruction1(IFIDInstructionType1E downto IFIDInstructionType1S);
instructPartCurrentIns1 <= currentInstruction1(IFIDInstructionOpCode1E downto IFIDInstructionOpCode1S);

typePartCurrentIns2 <= currentInstruction2(IFIDInstructionType2E downto IFIDInstructionType2S);
instructPartCurrentIns2 <= currentInstruction2(IFIDInstructionOpCode2E downto IFIDInstructionOpCode2S);

typePartNextIns1 <= nextInstruction1(IFIDInstructionType1E downto IFIDInstructionType1S);
instructPartNextIns1 <= nextInstruction1(IFIDInstructionOpCode1E downto IFIDInstructionOpCode1S);

typePartNextIns2 <= nextInstruction2(IFIDInstructionType2E downto IFIDInstructionType2S);
instructPartNextIns2 <= nextInstruction2(IFIDInstructionOpCode2E downto IFIDInstructionOpCode2S);

currentInstruction1dst <= currentInstruction1(IFIDRdst1E downto IFIDRdst1S );
currentInstruction2src <= currentInstruction2(IFIDRsrc2E downto IFIDRsrc2S );
currentInstruction2dst <= currentInstruction2(IFIDRdst2E downto IFIDRdst2S );

addedToPC <= "00" when ((typePartNextIns1= MemoryInstruction) and ((instructPartNextIns1= OpCodeLDM) or (instructPartNextIns1=OpCodeLDD))) 
else "01" when ((currentInstruction1dst=currentInstruction2src) or (currentInstruction1dst=currentInstruction2dst)
or ((typePartCurrentIns1= oneOperandInstruction) and ((instructPartCurrentIns1= OpCodeIN) and (instructPartCurrentIns1=OpCodeIN)))
or ((typePartCurrentIns1= oneOperandInstruction) and ((instructPartCurrentIns1= OpCodeOUT) and (instructPartCurrentIns1=OpCodeOUT)))
or ((typePartCurrentIns1= oneOperandInstruction) and ((instructPartCurrentIns1= OpCodePUSH) and (instructPartCurrentIns1=OpCodePUSH)))
or ((typePartCurrentIns1= oneOperandInstruction) and ((instructPartCurrentIns1= OpCodePOP) and (instructPartCurrentIns1=OpCodePOP)))
or ((typePartCurrentIns1= oneOperandInstruction) and ((instructPartCurrentIns1= OpCodeLDD) and (instructPartCurrentIns1=OpCodeLDD)))
or ((typePartCurrentIns1= oneOperandInstruction) and ((instructPartCurrentIns1= OpCodeSTD) and (instructPartCurrentIns1=OpCodeSTD)))
or ((typePartCurrentIns1= oneOperandInstruction) and ((instructPartCurrentIns1= OpCodeCALL) and (instructPartCurrentIns1=OpCodeCALL)))
or ((typePartCurrentIns1= oneOperandInstruction) and ((instructPartCurrentIns1= OpCodeRET) and (instructPartCurrentIns1=OpCodeRET))))
else "10";


 

    
END ARCHITECTURE;