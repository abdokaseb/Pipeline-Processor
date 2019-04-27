Library IEEE;
use ieee.std_logic_1164.all;
use work.constants.all;

-- BuffwithFlushGen Entity

ENTITY BuffwithFlushGen IS
    GENERIC (buffType: buffer_type := IFID; len: INTEGER := IFIDLength+1);
    PORT( 
        buffD: IN STD_LOGIC_VECTOR(len-1 DOWNTO 0);
        en,clk,rst : IN STD_LOGIC;
        buffQ : OUT STD_LOGIC_VECTOR(len-1 DOWNTO 0);
        flushVector : IN STD_LOGIC_VECTOR(0 TO 2)
    );
                        
END ENTITY BuffwithFlushGen;

----------------------------------------------------------------------
-- BuffwithFlushGen Architecture

ARCHITECTURE BuffwithFlushGenArch OF BuffwithFlushGen IS
BEGIN

    BUFGENIFID: IF buffType = IFID GENERATE
        SIGNAL firstD ,firstQ : STD_LOGIC_VECTOR (IFIDInstruction1E DOWNTO IFIDInstruction1S);
        SIGNAL secondD ,secondQ : STD_LOGIC_VECTOR (IFIDInstruction2E DOWNTO IFIDInstruction2S);
        SIGNAL commonD ,commonQ : STD_LOGIC_VECTOR (IFIDLength DOWNTO IFIDBOTHS);
        firstD <= (OTHERS => '0' ) WHEN flushVector(0) = '1' ELSE buffD(IFIDInstruction1E DOWNTO IFIDInstruction1S);
        secondD <= (OTHERS => '0' ) WHEN flushVector(1) = '1' ELSE buffD(IFIDInstruction2E DOWNTO IFIDInstruction2S);
        commonD <= (OTHERS => '0' ) WHEN flushVector(2) = '1' ELSE buffD(IFIDLength DOWNTO IFIDBOTHS);
        buffQ <=  commonQ & secondQ & firstQ;

        firstBUFF: ENTITY work.Reg GENERIC MAP (firstD'LENGTH) PORT MAP ( firstD ,en ,clk ,rst ,firstQ );
        secondBUFF: ENTITY work.Reg GENERIC MAP (secondD'LENGTH) PORT MAP ( secondD ,en ,clk ,rst ,secondQ );
        COMONBUFF: ENTITY work.Reg GENERIC MAP (commonD'LENGTH) PORT MAP ( commonD ,en ,clk ,rst ,commonQ );
    END GENERATE;
---------------------------
    BUFGENIDEX: IF buffType = IDEX GENERATE
        SIGNAL firstD ,firstQ : STD_LOGIC_VECTOR (IDEXInc1E DOWNTO IDEXInc1S);
        SIGNAL secondD ,secondQ : STD_LOGIC_VECTOR (IDEXInc2E DOWNTO IDEXInc2S);
        SIGNAL commonD ,commonQ : STD_LOGIC_VECTOR (IDEXLength DOWNTO IDEXBOTHS);
        firstD <= (OTHERS => '0' ) WHEN flushVector(0) = '1' ELSE buffD(IDEXInc1E DOWNTO IDEXInc1S);
        secondD <= (OTHERS => '0' ) WHEN flushVector(1) = '1' ELSE buffD(IDEXInc2E DOWNTO IDEXInc2S);
        commonD <= (OTHERS => '0' ) WHEN flushVector(2) = '1' ELSE buffD(IDEXLength DOWNTO IDEXBOTHS);
        buffQ <=  commonQ & secondQ & firstQ;
        
        firstBUFF: ENTITY work.Reg GENERIC MAP (firstD'LENGTH) PORT MAP ( firstD ,en ,clk ,rst ,firstQ );
        secondBUFF: ENTITY work.Reg GENERIC MAP (secondD'LENGTH) PORT MAP ( secondD ,en ,clk ,rst ,secondQ );
        COMONBUFF: ENTITY work.Reg GENERIC MAP (commonD'LENGTH) PORT MAP ( commonD ,en ,clk ,rst ,commonQ );
    END GENERATE;
---------------------------
    BUFGENEXMEM: IF buffType = EXMEM GENERATE
        SIGNAL firstD ,firstQ : STD_LOGIC_VECTOR (EXMEMInc1E DOWNTO EXMEMInc1S);
        SIGNAL secondD ,secondQ : STD_LOGIC_VECTOR (EXMEMInc2E DOWNTO EXMEMInc2S);
        SIGNAL commonD ,commonQ : STD_LOGIC_VECTOR (EXMEMLength DOWNTO EXMEMBOTHS);
        firstD <= (OTHERS => '0' ) WHEN flushVector(0) = '1' ELSE buffD(EXMEMInc1E DOWNTO EXMEMInc1S);
        secondD <= (OTHERS => '0' ) WHEN flushVector(1) = '1' ELSE buffD(EXMEMInc2E DOWNTO EXMEMInc2S);
        commonD <= (OTHERS => '0' ) WHEN flushVector(2) = '1' ELSE buffD(EXMEMLength DOWNTO EXMEMBOTHS);
        buffQ <=  commonQ & secondQ & firstQ;

        firstBUFF: ENTITY work.Reg GENERIC MAP (firstD'LENGTH) PORT MAP ( firstD ,en ,clk ,rst ,firstQ );
        secondBUFF: ENTITY work.Reg GENERIC MAP (secondD'LENGTH) PORT MAP ( secondD ,en ,clk ,rst ,secondQ );
        COMONBUFF: ENTITY work.Reg GENERIC MAP (commonD'LENGTH) PORT MAP ( commonD ,en ,clk ,rst ,commonQ );
    END GENERATE;

END ARCHITECTURE;