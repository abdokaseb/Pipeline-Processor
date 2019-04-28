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
        EXMEMbufferOut : out STD_LOGIC_VECTOR(EXMEMLength downto 0)
    );
                        
END ENTITY ControlHazardsUnit;

----------------------------------------------------------------------
-- ControlHazardsUnit Architecture

ARCHITECTURE ControlHazardsUnitArch OF ControlHazardsUnit IS
    signal condition1,condition2: BOOLEAN;
    signal branch1OpCode,branch2OpCode : STD_LOGIC_VECTOR(2 downto 0);
BEGIN
    condition1 <= IDEXbuffer(IDEXBranchOrNot1) = '1' and ( branch1OpCode(2) = '1' or -- unconditional
        (branch1OpCode = OpCodeJZ and FlagsToALU1(zFlag) = '1') or
        (branch1OpCode = OpCodeJC and FlagsToALU1(cFlag) = '1') or
        (branch1OpCode = OpCodeJN and FlagsToALU1(nFlag) = '1'));

    condition2 <= IDEXbuffer(IDEXBranchOrNot2) = '1' and (
        branch2OpCode(2) = '1' or -- unconditional
        (branch2OpCode = OpCodeJZ and FlagsToALU2(zFlag) = '1') or
        (branch2OpCode = OpCodeJC and FlagsToALU2(cFlag) = '1') or
        (branch2OpCode = OpCodeJN and FlagsToALU2(nFlag) = '1')) and not condition1 ; -- condtion 1 is the dominant

    PCWBFromEX <= '1' when ( condition1 and ((branch1OpCode = OpCodeCALL) or (branch1OpCode(2) = '0')) )  or ( condition2 and ((branch2OpCode = OpCodeCALL) or (branch2OpCode(2) = '0')) ) else '0';
    PCFromEX <= (15 downto 0 =>'0') & Rdst1FRWval when condition1 else (15 downto 0 =>'0') & Rdst2FRWval; -- PCWBFromEX is more important

    IFIDflushVector <= (others => '1') when condition1 or condition2 or keepFlushing = '1' else (others => '0');
    IDEXflushVector <= (others => '1') when condition1 or condition2 or keepFlushing = '1' else (others => '0');

    EXMEMflushVector(0 TO 2) <= ("011") when condition1 and branch1OpCode(2) = '0' else
                                ("010") when condition1 and branch1OpCode(2) = '1' else 
                                (others => '1') when keepFlushing ='1' else
                                (others => '0');

    EXMEMbufferOut(EXMEMDSBE downto EXMEMDSBS) <=  branch1OpCode(1 downto 0) when condition1 and branch1OpCode(2) = '1' else
                                                branch2OpCode(1 downto 0) when condition2 and branch2OpCode(2) = '1' else
                                                (others => '0');

END ARCHITECTURE;