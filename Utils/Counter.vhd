LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.numeric_std.all;

-- Counter entity

-- load ==> a parallel load to the counter
-- reset ==> 1 to reset the counter
-- isLoad ==> 1 to put the parallel load in the counter
-- count ==> output of the counter

ENTITY Counter IS

    GENERIC (n: integer :=2);

    PORT(
        load: in std_logic_vector(n-1 downto 0);
        reset, clk, isLoad: in std_logic;
        count: out std_logic_vector(n-1 downto 0)
    );

END Counter;


ARCHITECTURE CounterArch OF Counter IS

    SIGNAL counterInput, countAdded, currentCount, resetOrCurrent: std_logic_vector(n-1 DOWNTO 0);

    BEGIN

        counterReg: ENTITY work.Reg GENERIC MAP(n) PORT MAP(counterInput, '1', clk, '0', currentCount);
        nextCount: ENTITY work.NBitAdder GENERIC MAP(n) PORT MAP(currentCount, (others => '0'), '1', countAdded);
        muxloadOrCurrent: ENTITY work.mux2 GENERIC MAP(n) PORT MAP(resetOrCurrent, load, isLoad, counterInput);
        muxInput: ENTITY work.mux2 GENERIC MAP(n) PORT MAP(countAdded, (others => '0'), reset, resetOrCurrent);
        count <= currentCount;

END ARCHITECTURE;