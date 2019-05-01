Library IEEE;
use ieee.std_logic_1164.all;
use work.constants.all;

-- AddToPC Entity

ENTITY AddToPC IS
	PORT(
            IFIDBuffer: in STD_LOGIC_VECTOR(IFIDLength DOWNTO 0);
            clk,rst: in STD_LOGIC;
            addedToPC: out STD_LOGIC_VECTOR(1 downto 0);
            MR1, MW1, WB1, MR2, MW2: in STD_LOGIC
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

    signal currentInstruction1src, currentInstruction1dst, currentInstruction2src, currentInstruction2dst, nextInstruction1dst, nextInstruction2dst :STD_LOGIC_VECTOR(2 downto 0);
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
nextInstruction1dst <= nextInstruction1(IFIDRdst1E downto IFIDRdst1S );

typePartNextIns2 <= nextInstruction2(IFIDInstructionType2E downto IFIDInstructionType2S);
instructPartNextIns2 <= nextInstruction2(IFIDInstructionOpCode2E downto IFIDInstructionOpCode2S);
nextInstruction2dst <= nextInstruction1(IFIDRdst1E downto IFIDRdst1S);

currentInstruction1src <= currentInstruction1(IFIDRsrc1E downto IFIDRsrc1S );
currentInstruction1dst <= currentInstruction1(IFIDRdst1E downto IFIDRdst1S );
currentInstruction2src <= currentInstruction2(IFIDRsrc2E downto IFIDRsrc2S );
currentInstruction2dst <= currentInstruction2(IFIDRdst2E downto IFIDRdst2S );

addedToPC <= "00" when (typePartNextIns1= MemoryInstruction and instructPartNextIns1= OpCodeLDD and (nextInstruction1dst=currentInstruction1src or nextInstruction1dst=currentInstruction1dst))
                    or (typePartNextIns2= MemoryInstruction and instructPartNextIns2= OpCodeLDD and (nextInstruction2dst=currentInstruction1src or nextInstruction2dst=currentInstruction1dst))
        else "01" when (typePartNextIns1= MemoryInstruction and instructPartNextIns1= OpCodeLDD and (nextInstruction1dst=currentInstruction2src or nextInstruction1dst=currentInstruction2dst))
                    or (typePartNextIns2= MemoryInstruction and instructPartNextIns2= OpCodeLDD and (nextInstruction2dst=currentInstruction2src or nextInstruction2dst=currentInstruction2dst))
                    or (WB1 = '1' and (currentInstruction1dst = currentInstruction2src or currentInstruction1dst = currentInstruction2dst))
                    or ((typePartCurrentIns1= oneOperandInstruction and instructPartCurrentIns1= OpCodeIN) and (typePartCurrentIns2= oneOperandInstruction and instructPartCurrentIns2= OpCodeIN))
                    or ((typePartCurrentIns1= oneOperandInstruction and instructPartCurrentIns1= OpCodeOUT) and (typePartCurrentIns2= oneOperandInstruction and instructPartCurrentIns2= OpCodeOUT))
                    or ((MR1 = '1' or MW1 = '1') and (MR2 = '1' or MW2 = '1'))
        else "10";

    
END ARCHITECTURE;