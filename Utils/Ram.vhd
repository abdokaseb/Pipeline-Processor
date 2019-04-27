LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;

ENTITY Ram IS

	Generic(addressBits: integer := 11; wordSize: integer :=16);

	PORT(
			clk : IN STD_LOGIC;
			we,rd,twoWords : IN STD_LOGIC;
			address : IN  STD_LOGIC_VECTOR(addressBits - 1 DOWNTO 0);
            datain1,datain2  : IN  STD_LOGIC_VECTOR(wordSize - 1 DOWNTO 0);
            dataout1,dataout2 : OUT STD_LOGIC_VECTOR(wordSize - 1 DOWNTO 0)
		);

END ENTITY Ram;

------------------------------------------------------------

ARCHITECTURE RamArch OF Ram IS

	TYPE RamType IS ARRAY(0 TO (2**addressBits) - 1) OF STD_LOGIC_VECTOR(wordSize - 1 DOWNTO 0);
	
	SIGNAL Ram : RamType ;
	
	BEGIN

		PROCESS(clk) IS
			BEGIN
				IF rising_edge(clk) THEN  
                    IF we = '1' THEN
                        IF twoWords = '1' THEN
                            Ram(TO_INTEGER(UNSIGNED(address))+1) <= datain2;
                        END IF;
                        Ram(TO_INTEGER(UNSIGNED(address))) <= datain1;
					END IF;
				END IF;
		END PROCESS;
        
		dataout1 <= (OTHERS => 'Z' ) WHEN rd /= '1' ELSE Ram(TO_INTEGER(UNSIGNED(address)));
        dataout2 <= (OTHERS => 'Z' ) WHEN rd /= '1' ELSE Ram(TO_INTEGER(UNSIGNED(address))+1);		

END ARCHITECTURE;