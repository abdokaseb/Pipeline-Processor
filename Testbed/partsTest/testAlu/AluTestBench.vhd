Library IEEE;
use ieee.std_logic_1164.all;
use work.constants.all;

-- testStateMachine Entity

ENTITY AluTestBench IS
PORT(
    clk:in std_logic
);
END ENTITY AluTestBench;

----------------------------------------------------------------------
-- testStateMachineister Architecture

ARCHITECTURE AluTestBenchArch of AluTestBench IS
SIGNAL A,B,F: STD_LOGIC_VECTOR(15 downto 0); -- two operand of alu
SIGNAL ShiftAmount: STD_LOGIC_VECTOR(4 downto 0); -- shift amount in case of shift operation
SIGNAL Operation: STD_LOGIC_VECTOR(3 downto 0);
SIGNAL flagIn,flagOut: STD_LOGIC_VECTOR(flagsCount-1 downto 0); -- shift amount in case of shift operation

-----      nzc

BEGIN	
 ALUentity : entity work.alu port map(
        A => A,
        B => B,
        F => F,
        shiftAm => ShiftAmount,
        operationControl => Operation,
        flagIn =>flagIn,
        flagOut => flagOut
    );
process 
    variable result:  std_logic_vector(16-1 downto 0);
    variable flagResult:  std_logic_vector(flagsCount-1 downto 0);
begin
    
    ---------- set cary -----------------------------------------------
    a <= x"XXXX";
    b <= x"XXXX"; 
    ShiftAmount<="XXXXX";
    flagIn<="XXX";
    Operation <=OperationSETC;               
	wait for 100 ns ;
    result :=x"0000"  ;
    flagResult:="XX1";
	assert (flagResult = flagOut) report "SETC---flag =   " & to_string(flagOut) &"  not equal to expected  "& to_string(flagResult)  severity error;
     ---------- clear cary   ---------------------------------------------------
    a <= x"XXXX";
    b <= x"XXXX"; 
    ShiftAmount<="XXXXX";
    flagIn<="XXX";
    Operation <=OperationCLRC;               
	wait for 100 ns ;
    result :=x"0000"  ;
    flagResult:="XX0";
    assert (flagResult = flagOut) report "clRC ---flag =   " & to_string(flagOut) &"  not equal to expected  "& to_string(flagResult)  severity error;

     ---------- NOT   ---------------------------------------------------
    a <= x"XXXX";
    b <= x"0000"; 
    ShiftAmount<="XXXXX";
    flagIn<="XXX";
    Operation <=OperationNOT;               
	wait for 100 ns ;
    result :=x"FFFF"  ;
    flagResult:="10X";
    assert (flagResult = flagOut) report "NOT case 1 ---flag =   " & to_string(flagOut) &"  not equal to expected  "& to_string(flagResult)  severity error;

    a <= x"XXXX";
    b <= x"FFFF"; 
    ShiftAmount<="XXXXX";
    flagIn<="XXX";
    Operation <=OperationNOT;               
	wait for 100 ns ;
    result :=x"0000"  ;
    flagResult:="01X";
    assert (flagResult = flagOut) report "NOT case 2 ---flag =   " & to_string(flagOut) &"  not equal to expected  "& to_string(flagResult)  severity error;
    ---------- --------------------------INC  ----------------------------------------------------------
     --- case 1 (odrinary inc  all flags =0)
    a <= x"XXXX"; -- not importnat 
    b <= x"0001"; 
    ShiftAmount<="XXXXX";
    flagIn<="XXX";
    Operation <=OperationINC;               
	wait for 100 ns ;
    result :=x"0002"  ;
    flagResult:="000";
    assert (flagResult = flagOut and result= F ) report "inc case2  ---flag =   " & to_string(flagOut) & "--- output = "&to_string(F) &"  not equal to expected flag "& to_string(flagResult)&" output ="&to_string(result)  severity error;
    
     --- case 2 (inc FFFF)
    a <= x"XXXX"; -- not importnat 
    b <= x"FFFF"; 
    ShiftAmount<="XXXXX";
    flagIn<="XXX";
    Operation <=OperationINC;               
	wait for 100 ns ;
    result :=x"0000"  ;
    flagResult:="011";
    assert (flagResult = flagOut and result= F ) report "inc case2  ---flag =   " & to_string(flagOut) & "--- output = "&to_string(F) &"  not equal to expected flag "& to_string(flagResult)&" output ="&to_string(result)  severity error;
    
     --- case 3 ( negative inc )
    a <= x"XXXX"; -- not importnat 
    b <= x"FFE0";  -- -32
    ShiftAmount<="XXXXX";
    flagIn<="XXX";
    Operation <=OperationINC;               
	wait for 100 ns ;
    result :=x"FFE1"  ;
    flagResult:="100";
    assert (flagResult = flagOut and result= F ) report "inc case3  ---flag =   " & to_string(flagOut) & "--- output = "&to_string(F) &"  not equal to expected flag "& to_string(flagResult)&" output ="&to_string(result)  severity error;
    
     ---------- --------------------------DEC  ----------------------------------------------------------
     --- case 1 (odrinary dec  all flags =0)
    a <= x"XXXX"; -- not importnat 
    b <= x"0010"; 
    ShiftAmount<="XXXXX";
    flagIn<="XXX";
    Operation <=OperationDEC;               
	wait for 100 ns ;
    result :=x"000F"  ;
    flagResult:="001";
    assert (flagResult = flagOut and result= F ) report "dec case1  ---flag =   " & to_string(flagOut) & "--- output = "&to_string(F) &"  not equal to expected flag "& to_string(flagResult)&" output ="&to_string(result)  severity error;

    --- case 2 ( B= 0000)
    a <= x"XXXX"; -- not importnat 
    b <= x"0000"; 
    ShiftAmount<="XXXXX";
    flagIn<="XXX";
    Operation <=OperationDEC;               
	wait for 100 ns ;
    result :=x"FFFF"  ;
    flagResult:="100";
    assert (flagResult = flagOut and result= F ) report "dec case2  ---flag =   " & to_string(flagOut) & "--- output = "&to_string(F) &"  not equal to expected flag "& to_string(flagResult)&" output ="&to_string(result)  severity error;

    --- case 3 ( dec negative number)
    a <= x"XXXX"; -- not importnat 
    b <= x"FFEF"; 
    ShiftAmount<="XXXXX";
    flagIn<="XXX";
    Operation <=OperationDEC;               
	wait for 100 ns ;
    result :=x"FFEE"  ;
    flagResult:="101";
    assert (flagResult = flagOut and result= F ) report "dec case3  ---flag =   " & to_string(flagOut) & "--- output = "&to_string(F) &"  not equal to expected flag "& to_string(flagResult)&" output ="&to_string(result)  severity error;



     ---------- --------------------------   MOV   ----------------------------------------------------------
     --- case 1 (odrinary dec  all flags =0)
    a <= x"0010"; 
    b <= x"XXXX"; -- not importnat 
    ShiftAmount<="XXXXX";
    flagIn<="XXX";
    Operation <=OperationMOV;               
	wait for 100 ns ;
    result :=x"0010"  ;
    flagResult:="XXX";
    assert (flagResult = flagOut and result= F ) report "MOV case  ---flag =   " & to_string(flagOut) & "--- output = "&to_string(F) &"  not equal to expected flag "& to_string(flagResult)&" output ="&to_string(result)  severity error;

    ---------- --------------------------   ADD   ----------------------------------------------------------
    --- case 1 (odrinary two positive numbers with no cary )
    a <= x"0010"; 
    b <= x"0010"; -- not importnat 
    ShiftAmount<="XXXXX";
    flagIn<="XXX";
    Operation <=OperationADD;               
	wait for 100 ns ;
    result :=x"0020"  ;
    flagResult:="000";
    assert (flagResult = flagOut and result= F ) report "add case1  ---flag =   " & to_string(flagOut) & "--- output = "&to_string(F) &"  not equal to expected flag "& to_string(flagResult)&" output ="&to_string(result)  severity error;

    --- case 2 (odrinary two positive numbers with  overflow number will be negative )
    a <= x"7FFF"; 
    b <= x"7FFF"; -- not importnat 
    ShiftAmount<="XXXXX";
    flagIn<="XXX";
    Operation <=OperationADD;               
	wait for 100 ns ;
    result :=x"FFFE"  ;
    flagResult:="100";
    assert (flagResult = flagOut and result= F ) report "add case2  ---flag =   " & to_string(flagOut) & "--- output = "&to_string(F) &"  not equal to expected flag "& to_string(flagResult)&" output ="&to_string(result)  severity error;

    --- case 3 (odrinary two positive numbers with  overflow number will be negative )
    a <= x"7FFF"; 
    b <= x"7FFF"; -- not importnat 
    ShiftAmount<="XXXXX";
    flagIn<="XXX";
    Operation <=OperationADD;               
	wait for 100 ns ;
    result :=x"FFFE"  ;
    flagResult:="100";
    assert (flagResult = flagOut and result= F ) report "add case3  ---flag =   " & to_string(flagOut) & "--- output = "&to_string(F) &"  not equal to expected flag "& to_string(flagResult)&" output ="&to_string(result)  severity error;

    --- case 4 (negative number with  positive  )
    a <= x"F320"; 
    b <= x"0005"; -- not importnat 
    ShiftAmount<="XXXXX";
    flagIn<="XXX";
    Operation <=OperationADD;               
	wait for 100 ns ;
    result :=x"F325"  ;
    flagResult:="100";
    assert (flagResult = flagOut and result= F ) report "add case4  ---flag =   " & to_string(flagOut) & "--- output = "&to_string(F) &"  not equal to expected flag "& to_string(flagResult)&" output ="&to_string(result)  severity error;

     --- case 5 (negative + positive = 0   )
    a <= x"FFFD"; 
    b <= x"0003"; 
    ShiftAmount<="XXXXX";
    flagIn<="XXX";
    Operation <=OperationADD;               
	wait for 100 ns ;
    result :=x"0000"  ;
    flagResult:="011";
    assert (flagResult = flagOut and result= F ) report "add case5  ---flag =   " & to_string(flagOut) & "--- output = "&to_string(F) &"  not equal to expected flag "& to_string(flagResult)&" output ="&to_string(result)  severity error;

    --- case 6 (negative + negative =  negative  )
    a <= x"FFFD";  -- -3
    b <= x"FFFD"; --  -3  
    ShiftAmount<="XXXXX";
    flagIn<="XXX";
    Operation <=OperationADD;               
	wait for 100 ns ;
    result :=x"FFFA"  ;  -- -6
    flagResult:="101";
    assert (flagResult = flagOut and result= F ) report "add case6  ---flag =   " & to_string(flagOut) & "--- output = "&to_string(F) &"  not equal to expected flag "& to_string(flagResult)&" output ="&to_string(result)  severity error;

    ---------- --------------------------   SUB   ----------------------------------------------------------
    --- A-b
    --- nzc
    --- case 1 (odrinary two positive numbers with no cary )
    a <= x"0010"; 
    b <= x"0001"; -- not importnat 
    ShiftAmount<="XXXXX";
    flagIn<="XXX";
    Operation <=OperationSUB;               
	wait for 100 ns ;
    result :=x"000F"  ;
    flagResult:="001";
    assert (flagResult = flagOut and result= F ) report "sub case1  ---flag =   " & to_string(flagOut) & "--- output = "&to_string(F) &"  not equal to expected flag "& to_string(flagResult)&" output ="&to_string(result)  severity error;

    --- case 2 (positive - negative )
    a <= x"0010"; 
    b <= x"FFFF";  
    ShiftAmount<="XXXXX";
    flagIn<="XXX";
    Operation <=OperationSUB;               
	wait for 100 ns ;
    result :=x"0011"  ;
    flagResult:="000";
    assert (flagResult = flagOut and result= F ) report "sub case2  ---flag =   " & to_string(flagOut) & "--- output = "&to_string(F) &"  not equal to expected flag "& to_string(flagResult)&" output ="&to_string(result)  severity error;

    ----- case 3 ( negative - negative =0 )
    a <= x"FFFF"; 
    b <= x"FFFF";  
    ShiftAmount<="XXXXX";
    flagIn<="XXX";
    Operation <=OperationSUB;               
	wait for 100 ns ;
    result :=x"0000"  ;
    flagResult:="011";
    assert (flagResult = flagOut and result= F ) report "sub case3  ---flag =   " & to_string(flagOut) & "--- output = "&to_string(F) &"  not equal to expected flag "& to_string(flagResult)&" output ="&to_string(result)  severity error;

    ----- case 4 ( negative - negative = positive )
    a <= x"FFFF"; 
    b <= x"F325";  
    ShiftAmount<="XXXXX";
    flagIn<="XXX";
    Operation <=OperationSUB;               
	wait for 100 ns ;
    result :=x"0CDA"  ;
    flagResult:="001";
    assert (flagResult = flagOut and result= F ) report "sub case4  ---flag =   " & to_string(flagOut) & "--- output = "&to_string(F) &"  not equal to expected flag "& to_string(flagResult)&" output ="&to_string(result)  severity error;


    ----- case 5 ( negative - positive = negative )
    a <= x"FFFF"; 
    b <= x"0003";  
    ShiftAmount<="XXXXX";
    flagIn<="XXX";
    Operation <=OperationSUB;               
	wait for 100 ns ;
    result :=x"FFFC"  ;
    flagResult:="101";
    assert (flagResult = flagOut and result= F ) report "sub case5  ---flag =   " & to_string(flagOut) & "--- output = "&to_string(F) &"  not equal to expected flag "& to_string(flagResult)&" output ="&to_string(result)  severity error;

    ---------- --------------------------   AND   ----------------------------------------------------------
    --- nzc
    --- case 1 ( 0 and F )
    a <= x"0000"; 
    b <= x"FFFF"; -- not importnat 
    ShiftAmount<="XXXXX";
    flagIn<="XXX";
    Operation <=OperationAND;               
	wait for 100 ns ;
    result :=x"0000"  ;
    flagResult:="01X";
    assert (flagResult = flagOut and result= F ) report "AND case1  ---flag =   " & to_string(flagOut) & "--- output = "&to_string(F) &"  not equal to expected flag "& to_string(flagResult)&" output ="&to_string(result)  severity error;

    --- nzc
    --- case 2 ( 0 and F )
    a <= x"C0C0"; 
    b <= x"C0C0"; -- not importnat 
    ShiftAmount<="XXXXX";
    flagIn<="XXX";
    Operation <=OperationAND;               
	wait for 100 ns ;
    result :=x"C0C0"  ;
    flagResult:="10X";
    assert (flagResult = flagOut and result= F ) report "AND case2  ---flag =   " & to_string(flagOut) & "--- output = "&to_string(F) &"  not equal to expected flag "& to_string(flagResult)&" output ="&to_string(result)  severity error;

    ---------- --------------------------   OR   ----------------------------------------------------------
    --- nzc
    --- case 1 
    a <= x"0000"; 
    b <= x"FFFF"; -- not importnat 
    ShiftAmount<="XXXXX";
    flagIn<="XXX";
    Operation <=OperationOR;               
	wait for 100 ns ;
    result :=x"FFFF"  ;
    flagResult:="10X";
    assert (flagResult = flagOut and result= F ) report "OR case1  ---flag =   " & to_string(flagOut) & "--- output = "&to_string(F) &"  not equal to expected flag "& to_string(flagResult)&" output ="&to_string(result)  severity error;

    --- nzc
    --- case 2 
    a <= x"0000"; 
    b <= x"0000"; -- not importnat 
    ShiftAmount<="XXXXX";
    flagIn<="XXX";
    Operation <=OperationOR;               
	wait for 100 ns ;
    result :=x"0000"  ;
    flagResult:="01X";
    assert (flagResult = flagOut and result= F ) report "OR case2  ---flag =   " & to_string(flagOut) & "--- output = "&to_string(F) &"  not equal to expected flag "& to_string(flagResult)&" output ="&to_string(result)  severity error;

    --- nzc
    --- case 3 
    a <= x"CCCC"; 
    b <= x"3333"; -- not importnat 
    ShiftAmount<="XXXXX";
    flagIn<="XXX";
    Operation <=OperationOR;               
	wait for 100 ns ;
    result :=x"FFFF"  ;
    flagResult:="10X";
    assert (flagResult = flagOut and result= F ) report "OR case3 ---flag =   " & to_string(flagOut) & "--- output = "&to_string(F) &"  not equal to expected flag "& to_string(flagResult)&" output ="&to_string(result)  severity error;

    ---------- --------------------------   SHL   ----------------------------------------------------------
    --- nzc
    --- case 1 
    a <= x"0000"; 
    b <= x"0019"; -- not importnat 
    ShiftAmount<="00010";
    flagIn<="XXX";
    Operation <=OperationSHL;               
	wait for 100 ns ;
    result :=x"0064"  ;
    flagResult:="000";
    assert (flagResult = flagOut and result= F ) report "SHL case1  ---flag =   " & to_string(flagOut) & "--- output = "&to_string(F) &"  not equal to expected flag "& to_string(flagResult)&" output ="&to_string(result)  severity error;

    --- nzc
    --- case 2
    a <= x"0000"; 
    b <= x"0080"; -- not importnat 
    ShiftAmount<="01001";
    flagIn<="XXX";
    Operation <=OperationSHL;               
	wait for 100 ns ;
    result :=x"0000"  ;
    flagResult:="011";
    assert (flagResult = flagOut and result= F ) report "SHL case2  ---flag =   " & to_string(flagOut) & "--- output = "&to_string(F) &"  not equal to expected flag "& to_string(flagResult)&" output ="&to_string(result)  severity error;

    ---------- --------------------------   SHR   ----------------------------------------------------------
    --- nzc
    --- case 1 
    a <= x"0000"; 
    b <= x"0064"; 
    ShiftAmount<="00011";
    flagIn<="XXX";
    Operation <=OperationSHR;               
	wait for 100 ns ;
    result :=x"000C"  ;
    flagResult:="001";
    assert (flagResult = flagOut and result= F ) report "SHR case1  ---flag =   " & to_string(flagOut) & "--- output = "&to_string(F) &"  not equal to expected flag "& to_string(flagResult)&" output ="&to_string(result)  severity error;

    wait;	
end process; 


end architecture;