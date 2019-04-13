Library IEEE;
use ieee.std_logic_1164.all;
use work.constants.all;

-- FlagsUnit Entity

ENTITY FlagsUnit IS
    Generic(ALUOperationSize:integer :=5);
	PORT(
            FlagsIn1,FlagsIn2: in STD_LOGIC_VECTOR(flagsCount-1 DOWNTO 0);
            ALUOperation1,ALUOperation2: in STD_LOGIC_VECTOR(ALUOperationSize-1 DOWNTO 0);
            FlagsOut1,FlagsOut2: out STD_LOGIC_VECTOR(flagsCount-1 DOWNTO 0)
		);

END ENTITY FlagsUnit;

----------------------------------------------------------------------
-- FlagsUnit Architecture

ARCHITECTURE FlagsUnitArch of FlagsUnit is

BEGIN



END ARCHITECTURE;