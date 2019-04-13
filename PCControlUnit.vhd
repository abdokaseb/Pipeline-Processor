Library IEEE;
use ieee.std_logic_1164.all;
use work.constants.all;

-- PCControlUnit Entity

ENTITY PCControlUnit IS
    Generic(PCSize: integer :=32);
	PORT(
        clk: in STD_LOGIC;
        PCReg: out STD_LOGIC_VECTOR(PCSize-1 DOWNTO 0)
    );

END ENTITY PCControlUnit;

----------------------------------------------------------------------
-- PCControlUnit Architecture

ARCHITECTURE PCControlUnitArch of PCControlUnit is

BEGIN
    

END ARCHITECTURE;