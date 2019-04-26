Library IEEE;
use ieee.std_logic_1164.all;

-- SP Register Entity

ENTITY SP IS

	Generic(wordSize:integer :=32);
	PORT(
			D: in STD_LOGIC_VECTOR(wordSize-1 DOWNTO 0);
			en, clk, rst: in STD_LOGIC;
            Q: out STD_LOGIC_VECTOR(wordSize-1 DOWNTO 0)
		);

END ENTITY SP;

----------------------------------------------------------------------
-- SP Register Architecture

ARCHITECTURE SPArch of SP is

BEGIN

	PROCESS(D,clk, en, rst)
		BEGIN
			IF rst ='1' THEN
                Q <= (others=>'1');
            ELSIF clk'EVENT AND clk='1' THEN
                IF en='1' THEN
                    Q <= D;
                END IF;
			END IF;

		END PROCESS;

END ARCHITECTURE;