Library IEEE;
use ieee.std_logic_1164.all;
use work.constants.all;

-- PCControlUnit Entity

ENTITY PCControlUnit IS
    Generic(PCSize: integer :=PCLength);
	PORT(
        clk,reset,ExPcEnable,MemPcEnable: in STD_LOGIC;
        ControlPCoperation: in STD_LOGIC_VECTOR(1 downto 0);
        ExPC,MemPc: in STD_LOGIC_Vector(PCSize-1 DownTO 0); 
        PCReg: out STD_LOGIC_VECTOR(PCSize-1 DOWNTO 0);
        InterruptS, InterruptE: in STD_LOGIC;
        inInterruptState: out STD_LOGIC
    );

END ENTITY PCControlUnit;

----------------------------------------------------------------------
-- PCControlUnit Architecture

ARCHITECTURE PCControlUnitArch of PCControlUnit is
    Signal PCcurrent,tempF ,tempA: STD_LOGIC_VECTOR(PCSize-1 DOWNTO 0);
    Signal Zeros: STD_LOGIC_VECTOR(PCSize-3 DOWNTO 0);
    signal latchedEnables: STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNal TempCarryOut: STD_LOGIC;
    signal inInterruptStateInternal: STD_LOGIC;
BEGIN
    fAdder: entity work.nbitAdder generic map(PCSize) port map(PCcurrent, tempA, '0', tempF, TempCarryOut);
Zeros <= (others => '0');
--( if 00  we will add 0 on (pc stall)  ) | (if 01 we will add 1 (swap) ) | (if 10 we will add 2 (ordinary increment) )
tempA <= (others => '0') when latchedEnables(0) = '1' or latchedEnables(1) = '1' or latchedEnables(2) = '1'
    else Zeros&ControlPCoperation;  
PCReg <= tempF;

    latchValuesEntity: entity work.Reg generic map(3) port map(ExPcEnable & MemPcEnable & inInterruptStateInternal, '1', clk,'0',latchedEnables);
    inInterruptState <= latchedEnables(2);
process (clk,reset)
    begin
        if (reset ='1') then 
            PCcurrent<=(x"00000000");         ----  assume no reset logic  (so i hardcoded the address of the programms in test cases)---
        elsif (clk'EVENT AND clk='1') then 
                if (MemPcEnable ='1') then 
                    PCcurrent<=MemPc;
                elsif (ExPcEnable ='1') then
                    PCcurrent<=ExPC;
                else 
                    PCcurrent <=tempF;
                end if;
        end if;
    end process;

process (InterruptS, InterruptE)
    begin
        if (InterruptS = '1') then
            inInterruptStateInternal <= '1';
        elsif (InterruptE = '1') then
            inInterruptStateInternal <= '0';
        else
            inInterruptStateInternal <= inInterruptStateInternal;
        end if;
    end process;


END ARCHITECTURE;