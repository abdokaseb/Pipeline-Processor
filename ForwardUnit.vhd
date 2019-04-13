Library IEEE;
use ieee.std_logic_1164.all;
use work.constants.all;

-- ForwardUnit Entity

ENTITY ForwardUnit IS
    Generic(wordSize:integer :=16);
	PORT(
            IDEXBuffer: in STD_LOGIC_VECTOR(IDEXLength DOWNTO 0);
            EXMEMBuffer: in STD_LOGIC_VECTOR(EXMEMLength DOWNTO 0);
            MEMWBBuffer: in STD_LOGIC_VECTOR(MEMWBLength DOWNTO 0);
            Src1,Dst1,Src2,Dst2: out STD_LOGIC_VECTOR(wordSize-1 DOWNTO 0)
		);

END ENTITY ForwardUnit;

----------------------------------------------------------------------
-- ForwardUnitister Architecture

ARCHITECTURE ForwardUnitArch of ForwardUnit is

BEGIN



END ARCHITECTURE;