
Library IEEE;
use ieee.std_logic_1164.all;
use work.constants.all;

-- testStateMachine Entity

ENTITY testStateMachine IS
PORT(
    isINT,rst,clk,b:in std_logic;
    c:out std_logic;
    a : out integer
);
END ENTITY testStateMachine;

----------------------------------------------------------------------
-- testStateMachineister Architecture

ARCHITECTURE testStateMachineArch of testStateMachine IS
TYPE INT_State_type IS (pushPC,pushFlags,readNewPC,r); -- INT state machine
SIGNAL INTstate : INT_State_type;
BEGIN	

      -------------- State Machines -----------
 
    PROCESS (isINT,INTstate,b)
    BEGIN
	if isINT = '1'  or  INTstate /= pushPC then
        CASE INTstate IS
        when pushPC =>
            a <= 10;  
	    c <= b;                            
        when pushFlags =>
            a <= 20; 
	    c <= not b;        
	when readNewPC =>
            a <= 30;
	    c<= b; 
        when r =>
            a <= 40; 
 		c<= not b;  
 	END CASE;
	else a<=999;
	end if;


    END PROCESS;
    PROCESS (rst,clk) 
    BEGIN
        if rst = '1' or (isINT /= '1' and INTstate = pushPC)  then
            INTstate <= pushPC;  
        else -- INT STATE MACHINE
            if rising_edge(clk) then
                    CASE INTstate IS
                            when pushPC =>
                                INTstate <= pushFlags;                              
                            when pushFlags =>
                                INTstate <= readNewPC;
                            when readNewPC =>
                                INTstate <= r;
                            when r =>
                                INTstate <= pushPC;
                    END CASE;
                end if;
        end if;
    END PROCESS;

END ARCHITECTURE;