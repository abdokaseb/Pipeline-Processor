LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.numeric_std.all;

-- Counter entity

-- load ==> a parallel load to the counter
-- reset ==> 1 to reset the counter
-- isLoad ==> 1 to put the parallel load in the counter
-- count ==> output of the counter

ENTITY CounterUpDown IS

    GENERIC (n: integer :=4);

    PORT(
        load,resetValue: in std_logic_vector(n-1 downto 0);
        clk, en, rst, isLoad,upOrDown: in std_logic;
        count: out std_logic_vector(n-1 downto 0)
    );

END CounterUpDown;


ARCHITECTURE CounterUpDownArch OF CounterUpDown IS

    SIGNAL  countAdded, currentCount,temp: std_logic_vector(n-1 DOWNTO 0);
    SIGNAL carry: STD_LOGIC ;

    BEGIN

        nextCount: ENTITY work.NBitAdder GENERIC MAP(n) PORT MAP(currentCount, temp, carry, countAdded);

        carry <= '1' when upOrDown ='0' else '0';
        temp <= (others => '0') when upOrDown ='0' else (others =>'1');
        
    PROCESS(currentCount,clk, en, rst)
		BEGIN
			IF rst ='1' THEN
                currentCount <= resetValue;
            ELSIF clk'EVENT AND clk='1' THEN
                IF (isLoad ='1')and(en='0') THEN
                    currentCount <=load;
                END IF;
                IF en='1' THEN
                    currentCount <= countAdded;
                END IF;
			END IF;

        END PROCESS;
        
        count <=currentCount;
        
END ARCHITECTURE;