Library IEEE;
use ieee.std_logic_1164.all;
use work.constants.all;

-- FlagsUnit Entity

ENTITY FlagsUnit IS
	PORT(
            FlagsFromALU1,FlagsFromALU2,FlagsFromMem : in STD_LOGIC_VECTOR(FlagsCount-1 DOWNTO 0);
            IsALUOper1,IsALUOper2 : in STD_LOGIC;
            ExMemDSB : in STD_LOGIC_VECTOR(1 DOWNTO 0);
            FlagsToALU1,FlagsToALU2,FlagsToMem: out STD_LOGIC_VECTOR(FlagsCount-1 DOWNTO 0);
            Buff2Flush,clk,rst :in STD_LOGIC
		);

END ENTITY FlagsUnit;

----------------------------------------------------------------------
-- FlagsUnit Architecture

ARCHITECTURE FlagsUnitArch of FlagsUnit is
    SIGNAL FlagsRegOut,FlagsRegIn : STD_LOGIC_VECTOR(FlagsCount-1 DOWNTO 0);
BEGIN
    FLAGSREG : ENTITY work.Reg generic map(FlagsCount) port map(FlagsRegIn,VCC,clk,rst,FlagsRegOut);
    FlagsToMem <= FlagsRegOut; -- alus will have no effect on as int flushes instuctions any way
    PROCESS (FlagsFromALU1,FlagsFromALU2,FlagsFromMem,isALUOper1,isALUOper2)
    BEGIN
        IF (ExMemDSB = OpCodeRTIDSB) THEN
            FlagsRegIn <= FlagsFromMem; 
            FlagsToALU1 <= (OTHERS =>'0'); -- RTI cases flush any way
            FlagsToALU2 <= (OTHERS =>'0');
        ELSIF (isALUOper1 = '1' AND isALUOper2 = '1' ) THEN
            FlagsToALU1 <= FlagsRegOut;
            FlagsToALU2 <= FlagsFromALU1; 
            FlagsRegIn <= FlagsFromALU2;
        ELSIF (isALUOper1 = '1') THEN
            FlagsToALU1 <= FlagsRegOut;
            FlagsToALU2 <= FlagsFromALU1; 
            FlagsRegIn <= FlagsFromALU1;	
        ELSIF (isALUOper2 = '1') THEN
            IF (Buff2Flush = '0') THEN
                FlagsToALU2 <= FlagsRegOut; 
                FlagsRegIn <= FlagsFromALU2;
            Else -- flush second instruction
                FlagsToALU2 <= (OTHERS =>'0');
            END IF;
        ELSE
            -- no ALU operations but may be branch or even push flags
            -- for push flags take any flags signal for push in stack ,as INT will flush alus and alus won't use flags any way
            FlagsToALU1 <= FlagsRegOut; 
            FlagsToALU2 <= FlagsRegOut;
        END IF;
    END PROCESS;

END ARCHITECTURE;