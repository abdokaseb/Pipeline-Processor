Library IEEE;
use ieee.std_logic_1164.all;
use work.constants.all;

-- ControlHazardsUnit Entity

ENTITY ControlHazardsUnit IS
    PORT( 
        IDEXbuffer : in STD_LOGIC_VECTOR(IDEXLength downto 0);
        FlagsToALU1,FlagsToALU2 : in STD_LOGIC_VECTOR(flagsCount-1 downto 0);
        Rdst1FRWval,Rdst2FRWval : in STD_LOGIC_VECTOR(15 downto 0);
        keepFlushing : in STD_LOGIC;
        IFIDflushVector , IDEXflushVector, EXMEMflushVector: out STD_LOGIC_VECTOR(0 TO 2);
        PCFromEX:out STD_LOGIC_VECTOR (31 downto 0);     
        PCWBFromEX:out STD_LOGIC;
        BranchExeFlags1,BranchExeFlags2 : out STD_LOGIC_VECTOR(flagsCount-1 downto 0);
        EXMEMbufferOut : out STD_LOGIC_VECTOR(EXMEMLength downto 0)
    );
                        
END ENTITY ControlHazardsUnit;

----------------------------------------------------------------------
-- ControlHazardsUnit Architecture

ARCHITECTURE ControlHazardsUnitArch OF ControlHazardsUnit IS
    signal condition1,isBranch1,unConditional1,zero1,neg1,carry1,isDSB1: BOOLEAN;
    signal condition2,isBranch2,unConditional2,zero2,neg2,carry2,isDSB2: BOOLEAN;
    signal branch1OpCode,branch2OpCode : STD_LOGIC_VECTOR(2 downto 0);
BEGIN
    isBranch1 <= IDEXbuffer(IDEXBranchOrNot1) = '1';
    branch1OpCode <= IDEXbuffer(IDEXOperationCode1E-1 downto IDEXOperationCode1S); -- least signifcant three bits only 
    zero1 <= branch1OpCode = OpCodeJZ and FlagsToALU1(zFlag) = '1';
    carry1 <= branch1OpCode = OpCodeJC and FlagsToALU1(cFlag) = '1';
    neg1 <= branch1OpCode = OpCodeJN and FlagsToALU1(nFlag) = '1';
    unConditional1 <= branch1OpCode(2) = '1';

    condition1 <= isBranch1 and ( unConditional1 or zero1 or carry1 or neg1);

    BranchExeFlags1 <= FlagsToALU1 and "011" when condition1 and neg1 else
                       FlagsToALU1 and "101" when condition1 and zero1 else
                       FlagsToALU1 and "110" when condition1 and carry1 else
                       FlagsToALU1;
    
    isDSB1 <= unConditional1 and branch1OpCode /= OpCodeJMP;

    --------------------------------------------------------------------------------------------------------------
    isBranch2 <= IDEXbuffer(IDEXBranchOrNot2) = '1';
    branch2OpCode <= IDEXbuffer(IDEXOperationCode2E-1 downto IDEXOperationCode2S);
    zero2 <= branch2OpCode = OpCodeJZ and FlagsToALU2(zFlag) = '1';
    carry2 <= branch2OpCode = OpCodeJC and FlagsToALU2(cFlag) = '1';
    neg2 <= branch2OpCode = OpCodeJN and FlagsToALU2(nFlag) = '1';
    unConditional2 <= branch2OpCode(2) = '1';

    condition2 <= IDEXbuffer(IDEXBranchOrNot2) = '1' and (unConditional2 or zero2 or carry2 or neg2 ) and not condition1; -- condtion 1 is the dominant

    BranchExeFlags2 <= FlagsToALU2 and "011" when condition2 and neg2 else
                       FlagsToALU2 and "101" when condition2 and zero2 else
                       FlagsToALU2 and "110" when condition2 and carry2 else
                       FlagsToALU2;

    isDSB2 <= unConditional2 and branch2OpCode /= OpCodeJMP;
    --------------------------------------------------------------------------------------------------------------

    PCWBFromEX <= '1' when (condition1 and ( (isDSB1 and branch1OpCode = OpCodeCALL) or not isDSB1) )  or ( condition2 and ( (isDSB2 and branch2OpCode = OpCodeCALL) or not isDSB2) ) else '0';
    PCFromEX <= (15 downto 0 => '0') & Rdst1FRWval when condition1 else (15 downto 0 =>'0') & Rdst2FRWval; -- PCWBFromEX is more important

    IFIDflushVector <= (others => '1') when condition1 or condition2 or keepFlushing = '1' else (others => '0');
    IDEXflushVector <= (others => '1') when condition1 or condition2 or keepFlushing = '1' else (others => '0');

    EXMEMflushVector(0 TO 2) <= ("011") when condition1 and branch1OpCode(2) = '0' else
                                ("010") when condition1 and branch1OpCode(2) = '1' else 
                                (others => '1') when keepFlushing ='1' else
                                (others => '0');

    EXMEMbufferOut(EXMEMDSBE downto EXMEMDSBS) <=  branch1OpCode(1 downto 0) when condition1 and isDSB1 else
                                                branch2OpCode(1 downto 0) when condition2 and isDSB2 else
                                                (others => '0');

END ARCHITECTURE;