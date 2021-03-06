library IEEE;
USE IEEE.std_logic_1164.all;
package constants is    

---Buffers
    TYPE buffer_type IS (IFIDbuff,IDEXbuff,EXMEMbuff,MEMWBbuff);
    constant IFID : buffer_type := IFIDbuff;
    constant IDEX : buffer_type := IDEXbuff;
    constant EXMEM : buffer_type := EXMEMbuff;
    constant MEMWB : buffer_type := MEMWBbuff;

--IF/ID buffer

    --/First instruction
    constant IFIDInstruction1S : integer := 0;

    constant IFIDShiftAmount1S : integer := 0;
    constant IFIDShiftAmount1E : integer := 4;
    constant IFIDRsrc1S : integer :=5;
    constant IFIDRsrc1E : integer :=7;
    constant IFIDRdst1S : integer :=8;
    constant IFIDRdst1E : integer :=10;
    constant IFIDInstructionOpCode1S : integer :=11;
    constant IFIDInstructionOpCode1E : integer :=13;
    constant IFIDInstructionType1S : integer :=14; 
    constant IFIDInstructionType1E : integer :=15; 

    constant IFIDInstruction1E : integer := 15;
    --/Second instruction
    constant IFIDInstruction2S : integer := 16;

    constant IFIDShiftAmount2S : integer := 16;
    constant IFIDShiftAmount2E : integer := 20;
    constant IFIDRsrc2S : integer :=21;
    constant IFIDRsrc2E : integer :=23;
    constant IFIDRdst2S : integer :=24;
    constant IFIDRdst2E : integer :=26;
    constant IFIDInstructionOpCode2S : integer :=27;
    constant IFIDInstructionOpCode2E : integer :=29;
    constant IFIDInstructionType2S : integer :=30; 
    constant IFIDInstructionType2E : integer :=31; 

    constant IFIDInstruction2E : integer := 31;
    --/Both instructions
    constant IFIDBOTHS : integer := 32;

    constant IFIDPCS : integer := 32;
    constant IFIDPCE : integer := 63;
    -- constant IFIDISINT : integer := 64;

    constant IFIDLength : integer := 63;


--ID/EX buffer

    --/First instruction
    constant IDEXInc1S : integer := 0;

    constant IDEXRdst1ValueS : integer := 0;        -- will be used in forwardunit 
    constant IDEXRdst1ValueE : integer := 15;
    constant IDEXRsrc1ValueS : integer := 16;
    constant IDEXRsrc1ValueE : integer := 31;
    constant IDEXRsrc1S  : integer := 32;
    constant IDEXRsrc1E  : integer := 34;
    constant IDEXRdst1S  : integer := 35;
    constant IDEXRdst1E  : integer := 37;
    constant IDEXMR1 : integer := 38;
    constant IDEXMW1 : integer := 39;
    constant IDEXWB1 : integer := 40;
    constant IDEXWriteTwoWords1 : integer := 41; -- won't be used ??!!
    constant IDEXStackOperation1 : integer := 42;
    constant IDEXShiftAmount1S : integer := 43;
    constant IDEXShiftAmount1E : integer := 47;
    constant IDEXOperationCode1S : integer := 48;
    constant IDEXOperationCode1E : integer := 51;
    constant IDEXOut1 : integer := 52;
    constant IDEXBranchOrNot1 : integer := 53;
    constant IDEXDSB1S : integer := 54;
    constant IDEXDSB1E : integer := 55;
    constant IDEXIsALUOper1 : integer := 56;
    constant IDEXIsNoForward1 : integer := 57;

    -- I'll leave 10 bits for additional features :D if you use it please down the number
    constant IDEXFreeInc1S : integer := 58;
    constant IDEXInc1E : integer := 65;


    --/Second instruction
    constant IDEXInc2S : integer := 66;

    constant IDEXRdst2ValueS : integer := 66;
    constant IDEXRdst2ValueE : integer := 81;
    constant IDEXRsrc2ValueS : integer := 82;
    constant IDEXRsrc2ValueE : integer := 97;
    constant IDEXRsrc2S : integer := 98;
    constant IDEXRsrc2E : integer := 100;
    constant IDEXRdst2S : integer := 101;
    constant IDEXRdst2E : integer := 103;
    constant IDEXMR2 : integer := 104;
    constant IDEXMW2 : integer := 105;
    constant IDEXWB2 : integer := 106;
    constant IDEXWriteTwowords2  : integer := 107;  -- won't be used ??!!
    constant IDEXStackOperation2 : integer := 108;
    constant IDEXShiftAmount2S : integer := 109;
    constant IDEXShiftAmount2E : integer := 113;
    constant IDEXOperationCode2S : integer := 114;
    constant IDEXOperationCode2E : integer := 117;
    constant IDEXOut2 : integer := 118;
    constant IDEXBranchOrNot2 : integer := 119;
    constant IDEXDSB2S : integer := 120;    -- Is it really important to put this here KASBE Ques
    constant IDEXDSB2E : integer := 121;
    constant IDEXIsALUOper2 : integer := 122;
    constant IDEXIsNoForward2 : integer := 123;


    -- I'll leave 10 bits for additional features :D if you use it please down the number
    constant IDEXFreeInc2S : integer := 124;
    constant IDEXInc2E : integer := 131;

    --/Both instructions
    constant IDEXBOTHS : integer := 132;

    constant IDEXPCS  : integer := 132;
    constant IDEXPCE  : integer := 163;
    constant IDEXisReset : integer := 164;
    constant IDEXISINT : integer := 165;

    constant IDEXLength : integer := 165;



--EX/MEM buffer 

    --/First instruction
    constant EXMEMInc1S : integer := 0;

    constant EXMEMResult1S : integer := 0;
    constant EXMEMResult1E : integer := 15;
    constant EXMEMWB1 : integer := 16;
    constant EXMEMRdst1S  : integer := 17;
    constant EXMEMRdst1E  : integer := 19;

    -- I'll leave 4 bits for additional features :D if you use it please down the number
    constant EXMEMFreeInc1S : integer := 20;
    constant EXMEMInc1E : integer := 22;

    --/Second instruction
    constant EXMEMInc2S : integer := 23;

    constant EXMEMResult2S : integer := 23;
    constant EXMEMResult2E : integer := 38;
    constant EXMEMWB2 : integer := 39;
    constant EXMEMRdst2S : integer := 40;
    constant EXMEMRdst2E : integer := 42;

    -- I'll leave 4 bits for additional features :D if you use it please down the number
    constant EXMEMFreeInc2S : integer := 43;
    constant EXMEMInc2E : integer := 45;

    --/Both instructions
    constant EXMEMBOTHS : integer := 46;

    constant EXMEMRsrcValFRWS : integer := 46;
    constant EXMEMRsrcValFRWE : integer := 61;
    constant EXMEMRdstValFRWS : integer := 62;
    constant EXMEMRdstValFRWE : integer := 77;
    --constant EXMEMAddressS: integer := 78; -- won't be used
    --constant EXMEMAddressE: integer := 97; -- won't be used
    constant EXMEMMW : integer := 78;
    constant EXMEMMR : integer := 79;
    constant EXMEMWriteTwowordsS : integer := 80; -- won't be used
    constant EXMEMDSBS : integer := 81;
    constant EXMEMDSBE : integer := 82;
    constant EXMEMPCS  : integer := 83;
    constant EXMEMPCE  : integer := 114;
    constant EXMEMFLAGSS : integer := 115;
    constant EXMEMFLAGSE : integer := 117;
    constant EXMEMWHICINSTR : integer := 118; -- this till which instruction access memory the upper or the lower
    constant EXMEMStackOperation : integer := 119; 
    constant EXMEMISINT : integer := 120;

    constant EXMEMLength : integer := 120;



--MEM/WB buffer 

    --/First instruction
    constant MEMWBInc1S : integer := 0;

    constant MEMWBWriteBackValue1S : integer := 0;
    constant MEMWBWriteBackValue1E : integer := 15;
    constant MEMWBWB1 : integer := 16;
    constant MEMWBRdst1S  : integer := 17;
    constant MEMWBRdst1E  : integer := 19;

    -- I'll leave 4 bits for additional features :D if you use it please down the number
    constant MEMWBFreeInc1S : integer := 20;
    constant MEMWBInc1E : integer := 22;

    --/Second instruction
    constant MEMWBInc2S : integer := 23;

    constant MEMWBWriteBackValue2S : integer := 23;
    constant MEMWBWriteBackValue2E : integer := 38;
    constant MEMWBWB2 : integer := 39;
    constant MEMWBRdst2S : integer := 40;
    constant MEMWBRdst2E : integer := 42;

    -- I'll leave 4 bits for additional features :D if you use it please down the number
    constant MEMWBFreeInc2S : integer := 43;
    constant MEMWBInc2E : integer := 45;

    --/Both instructions
    -- no common data

    constant MEMWBLength : integer := 45;



--instruction types
    constant twoOperandInstruction: std_logic_vector(1 downto 0) := "00";
    constant oneOperandInstruction: std_logic_vector(1 downto 0) := "01";
    constant MemoryInstruction: std_logic_vector(1 downto 0) := "10";
    constant branchInstruction: std_logic_vector(1 downto 0) := "11";


--registers
    constant R0: std_logic_vector(2 downto 0) := "000";
    constant R1: std_logic_vector(2 downto 0) := "001";
    constant R2: std_logic_vector(2 downto 0) := "010";
    constant R3: std_logic_vector(2 downto 0) := "011";
    constant R4: std_logic_vector(2 downto 0) := "100";
    constant R5: std_logic_vector(2 downto 0) := "101";
    constant R6: std_logic_vector(2 downto 0) := "110";
    constant R7: std_logic_vector(2 downto 0) := "111";


--ALU operations (for ALU and branch name in the document is "BranchType or operation code")
    constant OperationNOP: std_logic_vector(3 downto 0) :=  "0000";
    constant OperationMOV: std_logic_vector(3 downto 0) :=  "0001";
    constant OperationADD: std_logic_vector(3 downto 0) :=  "0010";
    constant OperationSUB: std_logic_vector(3 downto 0) :=  "0011";
    constant OperationAND: std_logic_vector(3 downto 0) :=  "0100";
    constant OperationOR: std_logic_vector(3 downto 0) :=  "0101";
    constant OperationSHL: std_logic_vector(3 downto 0) :=  "1110";
    constant OperationSHR: std_logic_vector(3 downto 0) :=  "1111";
    constant OperationSETC: std_logic_vector(3 downto 0) :=  "1001";
    constant OperationCLRC: std_logic_vector(3 downto 0) :=  "1010";
    constant OperationNOT: std_logic_vector(3 downto 0) :=  "1011";
    constant OperationINC: std_logic_vector(3 downto 0) :=  "1100";
    constant OperationDEC: std_logic_vector(3 downto 0) :=  "1101";
    -- constant OperationOUT: std_logic_vector(3 downto 0) :=  "1110";
    -- constant OperationIN: std_logic_vector(3 downto 0) :=  "1111";
    -- constant OperationPUSH: std_logic_vector(3 downto 0) :=  "0011";
    -- constant OperationPOP: std_logic_vector(3 downto 0) :=  "0100";
    -- constant OperationLDM: std_logic_vector(3 downto 0) :=  "0101";
    -- constant OperationLDD: std_logic_vector(3 downto 0) :=  "0110";
    -- constant OperationSTD: std_logic_vector(3 downto 0) :=  "0111";
    constant OperationJZ: std_logic_vector(3 downto 0) :=  "0001";
    constant OperationJN: std_logic_vector(3 downto 0) :=  "0010";
    constant OperationJC: std_logic_vector(3 downto 0) :=  "0011";
    constant OperationJMP: std_logic_vector(3 downto 0) :=  "0100";
    constant OperationCALL: std_logic_vector(3 downto 0) :=  "0101";
    constant OperationRET: std_logic_vector(3 downto 0) :=  "0110";
    constant OperationRTI: std_logic_vector(3 downto 0) :=  "0111";


--Op code for all instructions (just like the document)
    constant OpCodeNOP: std_logic_vector(2 downto 0) :=  "000";
    constant OpCodeMOV: std_logic_vector(2 downto 0) :=  "001";
    constant OpCodeADD: std_logic_vector(2 downto 0) :=  "010";
    constant OpCodeSUB: std_logic_vector(2 downto 0) :=  "011";
    constant OpCodeAND: std_logic_vector(2 downto 0) :=  "100";
    constant OpCodeOR: std_logic_vector(2 downto 0) :=  "101";
    constant OpCodeSHL: std_logic_vector(2 downto 0) :=  "110";
    constant OpCodeSHR: std_logic_vector(2 downto 0) :=  "111";
    constant OpCodeSETC: std_logic_vector(2 downto 0) :=  "001";
    constant OpCodeCLRC: std_logic_vector(2 downto 0) :=  "010";
    constant OpCodeNOT: std_logic_vector(2 downto 0) :=  "011";
    constant OpCodeINC: std_logic_vector(2 downto 0) :=  "100";
    constant OpCodeDEC: std_logic_vector(2 downto 0) :=  "101";
    constant OpCodeOUT: std_logic_vector(2 downto 0) :=  "110";
    constant OpCodeIN: std_logic_vector(2 downto 0) :=  "111";
    constant OpCodePUSH: std_logic_vector(2 downto 0) :=  "011";
    constant OpCodePOP: std_logic_vector(2 downto 0) :=  "100";
    constant OpCodeLDM: std_logic_vector(2 downto 0) :=  "101";
    constant OpCodeLDD: std_logic_vector(2 downto 0) :=  "110";
    constant OpCodeSTD: std_logic_vector(2 downto 0) :=  "111";
    constant OpCodeJZ: std_logic_vector(2 downto 0) :=  "001";
    constant OpCodeJN: std_logic_vector(2 downto 0) :=  "010";
    constant OpCodeJC: std_logic_vector(2 downto 0) :=  "011";
    constant OpCodeJMP: std_logic_vector(2 downto 0) :=  "100";
    constant OpCodeCALL: std_logic_vector(2 downto 0) :=  "101";
    constant OpCodeRET: std_logic_vector(2 downto 0) :=  "110";
    constant OpCodeRTI: std_logic_vector(2 downto 0) :=  "111";

-- Op code for DSB
    constant OpCodeCALLDSB: std_logic_vector(1 downto 0) :=  OpCodeCALL(1 downto 0);
    constant OpCodeRETDSB: std_logic_vector(1 downto 0) :=  OpCodeRET(1 downto 0);
    constant OpCodeRTIDSB: std_logic_vector(1 downto 0) :=  OpCodeRTI(1 downto 0);
    constant OpCodeNODSB: std_logic_vector(1 downto 0) :=  "00";

--flags 
    constant flagsCount: integer :=3;
    constant cFlag: integer :=0;
    constant zFlag: integer :=1;
    constant nFlag: integer :=2;

--VCC and GND
    constant VCC : STD_LOGIC := '1';
    constant GND : STD_LOGIC := '0';

-- PC/SP length
    constant PCLength: integer :=32;
    constant SPLength: integer :=32;

    constant RAMaddressBits: integer := 11;

-- Defualt INT address
    constant DefaultIntAddress: integer := 2;
    constant DefaultResetPcAddress : integer := 0;
end constants;
    

