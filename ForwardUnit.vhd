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
    -----------  selection signals the will determine which value will be forwarded
    signal IdEXRsc1,IdEXRdst1,IdEXRsc2,IdEXRdst2 : STD_LOGIC_Vector (2 downto 0);
    signal ExMemRdst1,ExMemRdst2 : STD_LOGIC_Vector (2 downto 0);
    signal ExMemWb1,ExMemWb2 : STD_LOGIC;
    signal MemWbRdst1,MemWbRdst2 : STD_LOGIC_Vector (2 downto 0);
    signal MemWbWb1,MemWbWb2 : STD_LOGIC;       
    
    ----------     from above signal we determine the output value between the next values 
    Signal RSrc1Value,RDst1Value,RSrc2Value,RDst2Value:  STD_LOGIC_VECTOR(wordSize-1 DOWNTO 0);  ------- the originals value if there is no forwarding 
    Signal AluResult1,AluResult2:  STD_LOGIC_VECTOR(wordSize-1 DOWNTO 0);  ------- the forwarding from Ex|mem buffer 
    Signal WbValue1,WbValue2:  STD_LOGIC_VECTOR(wordSize-1 DOWNTO 0);    ----- the forwarding from mem/Wb buffer

    -----------------------------------------------------

    -- notes -----------

    -- 1- priority is for ex\mem forwarding so it is the first condition in if else statement 
    -- 2- we have assumed no two instructions in the same batch will write back in the same register 
    --     but make the second issue have the higer priority 
     
      ------------       |3|  |   |1|
      -----------        |4|  |   |2|          4 is the highest priotity

BEGIN
    ----------------------------------------------------------
    process (IdEXRsc1,ExMemRdst1,ExMemRdst2,ExMemWb1,ExMemWb2,MemWbRdst1,MemWbRdst2,MemWbWb1,MemWbWb2)
        begin 
            if ((ExMemWb2='1') and (ExMemRdst2 =IdEXRsc1) ) then 
                Src1 <= AluResult2;
            elsif ((ExMemWb1='1') and (ExMemRdst1 =IdEXRsc1) ) then 
                Src1 <= AluResult1;
            elsif (MemWbWb2='1' and (MemWbRdst2 =IdEXRsc1) ) then 
                Src1 <= WbValue2;
            elsif (MemWbWb1='1' and (MemWbRdst1 =IdEXRsc1) ) then 
                Src1 <= WbValue1;
            else 
                Src1 <= RSrc1Value;
            end if;
            
        end process;
    ----------------------------------------------------------------------

    ----------------------------------------------------------
    process (IdEXRdst1,ExMemRdst1,ExMemRdst2,ExMemWb1,ExMemWb2,MemWbRdst1,MemWbRdst2,MemWbWb1,MemWbWb2)
        begin 
            if (ExMemWb2='1' and (ExMemRdst2 =IdEXRdst1) ) then 
                Dst1 <= AluResult2;
            elsif (ExMemWb1='1' and (ExMemRdst1 =IdEXRdst1) ) then 
                Dst1 <= AluResult1;
            elsif (MemWbWb2='1' and (MemWbRdst2 =IdEXRdst1) ) then 
                Dst1 <= WbValue2;
            elsif (MemWbWb1='1'and (MemWbRdst1 =IdEXRdst1) ) then 
                Dst1 <= WbValue1;
            else 
                Dst1 <= RDst1Value;
            end if;

            
        end process;
    ----------------------------------------------------------------------


  ----------------------------------------------------------
    process (IdEXRsc2,ExMemRdst1,ExMemRdst2,ExMemWb1,ExMemWb2,MemWbRdst1,MemWbRdst2,MemWbWb1,MemWbWb2)
        begin 
            if (ExMemWb2='1' and (ExMemRdst2 =IdEXRsc2) ) then 
                Src2 <= AluResult2;
            elsif (ExMemWb1='1' and (ExMemRdst1 =IdEXRsc2) ) then 
                Src2 <= AluResult1;
            elsif (MemWbWb2='1' and (MemWbRdst2 =IdEXRsc2) ) then 
                Src2 <= WbValue2;
            elsif (MemWbWb1='1' and (MemWbRdst1 =IdEXRsc2) ) then 
                Src2 <= WbValue1;
            else 
                Src2 <= RSrc2Value;
            end if;

            
        end process;
    ----------------------------------------------------------------------


    ----------------------------------------------------------
    process (IdEXRdst2,ExMemRdst1,ExMemRdst2,ExMemWb1,ExMemWb2,MemWbRdst1,MemWbRdst2,MemWbWb1,MemWbWb2)
        begin 
            if (ExMemWb2='1' and (ExMemRdst2 =IdEXRdst2) ) then 
                Dst2 <= AluResult2;
            elsif (ExMemWb1='1' and (ExMemRdst1 =IdEXRdst2) ) then 
                Dst2 <= AluResult1;
            elsif (MemWbWb2='1' and (MemWbRdst2 =IdEXRdst2) ) then 
                Dst2 <= WbValue2;
            elsif (MemWbWb1='1' and (MemWbRdst1 =IdEXRdst2) ) then 
                Dst2 <= WbValue1;
            else 
                Dst2 <= RDst2Value;  
             end if;

        end process;
    ---------------------------------------------------------------------
    
    

END ARCHITECTURE;