Library IEEE;
use ieee.std_logic_1164.all;
use work.constants.all;

-- OutInstrUnit Entity

ENTITY OutInstrUnit IS
	PORT(
        Rdst1FRWval,Rdst2FRWval: in STD_LOGIC_VECTOR(15 downto 0);
        isOut1,isOut2: in STD_LOGIC;
        OutOfOut: out STD_LOGIC_VECTOR(15 downto 0)
		);

END ENTITY OutInstrUnit;

----------------------------------------------------------------------
-- OutInstrUnit Architecture

ARCHITECTURE OutInstrUnitArch OF OutInstrUnit IS
BEGIN
    OutOfOut  <= Rdst1FRWval when isOut1 = '1' else 
                 Rdst2FRWval when isOut2 = '1' else
                 (others => '0');
END ARCHITECTURE;