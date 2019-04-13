library IEEE;
use IEEE.std_logic_1164.all;
USE IEEE.numeric_std.all;
USE work.constants.all;

entity alu is
    generic(n: integer := 16;
            m: integer := 4;
            nshift: integer := 5);

    port(
        A, B: in std_logic_vector(n-1 downto 0);
        F: out std_logic_vector(n-1 downto 0);
        shiftAm: in std_logic_vector(nshift-1 downto 0);
        operationControl: in std_logic_vector(m-1 downto 0);
        flagIn: in std_logic_vector(flagsCount-1 downto 0);
        flagOut: out std_logic_vector(flagsCount-1 downto 0));
end entity alu;



architecture aluArch of alu is


    signal tempA, tempB, tempF: std_logic_vector(n-1 downto 0);
    signal tempCarryIn, tempCarryOut: std_logic;
    signal zeroSignal: std_logic_vector(n-1 downto 0);

    signal FTemp: std_logic_vector(n-1 downto 0);

    begin

        F <= FTemp;
        zeroSignal <= (others => '0');

        --operation codes
        -- transfer (A)
        -- ADD (A + B)
        -- ADC (A + B + carry)
        -- SUB (B - A)
        -- SBC (B - A - carry)
        -- AND (A and B)
        -- OR (A or B)
        -- XNOR (A xnor B)
        -- INC (B + 1)
        -- DEC (B - 1)
        -- CLR
        -- INV (not B)
        -- all one operand operation are on B
        -- LSR
        -- ROR
        -- RRC
        -- ASR
        -- LSL
        -- ROL
        -- RLC


        fAdder: entity work.nbitAdder generic map(n) port map(tempB, tempA, tempCarryIn, tempF, tempCarryOut);

        tempB <= B;

        tempA <= not(A) when operationControl = OperationSUB
        else (others => '0') when operationControl = OperationINC
        else (others => '1') when operationControl = OperationDEC
        else A;

        tempCarryIn <= '0' when operationControl = OperationADD or operationControl = OperationDEC
        else '1' when operationControl = OperationSUB or operationControl = OperationINC
        else flagIn(cFlag);

        FTemp <= A                                  when operationControl = OperationMOV
        else (others => '0')                        when (operationControl = OperationNOP or operationControl = OperationSETC
                                                    or   operationControl= OperationCLRC )
        else tempF                                  when (operationControl = OperationADD or operationControl = OperationSUB
                                                    or    operationControl = OperationINC or operationControl = OperationDEC )
        else (A and B)                              when operationControl = OperationAND
        else (A or B)                               when operationControl = OperationOR
        else not(B)                                 when operationControl = OperationNOT
        else B(n - 1 - TO_INTEGER(UNSIGNED(shiftAm)) downto 0) & (TO_INTEGER(UNSIGNED(shiftAm))-1 downto 0 => '0')  when operationControl = OperationSHL
        else (TO_INTEGER(UNSIGNED(shiftAm))-1 downto 0 => '0') & B(n - 1 downto TO_INTEGER(UNSIGNED(shiftAm)))  when operationControl = OperationSHR

        else (others => 'Z');

        --carry flag
        flagOut(cFlag) <= tempCarryOut          when operationControl = OperationADD or operationControl = OperationSUB  
                                                            or  operationControl = OperationINC or  operationControl = OperationDEC
        else B(TO_INTEGER(UNSIGNED(shiftAm))-1)     when  operationControl = OperationSHR
        else B(n-TO_INTEGER(UNSIGNED(shiftAm)))   when operationControl = OperationSHL
        else '1'                                when operationControl = OperationSETC
        else '0'                                when operationControl = OperationCLRC
        else flagIn(cFlag);
        
        --zero flag
        flagOut(zFlag) <= '1' when  FTemp = zeroSignal
                        else '0';
        --negative flag
        flagOut(nFlag) <= FTemp(n-1);
        
        
end architecture;