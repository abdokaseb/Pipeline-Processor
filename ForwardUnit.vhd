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
    signal ExMemWriteback1,ExMemWriteback2 : STD_LOGIC;
    signal MemWbRdst1,MemWbRdst2 : STD_LOGIC_Vector (2 downto 0);
    signal MemWbWriteback1,MemWbWriteback2 : STD_LOGIC;       
    Signal noForwarding1,noForwarding2: STD_LOGIC;
    
    ----------     from above signal we determine the output value between the next values 
    Signal RSrc1Value,RDst1Value,RSrc2Value,RDst2Value:  STD_LOGIC_VECTOR(wordSize-1 DOWNTO 0);  ------- the originals value if there is no forwarding 
    Signal AluResult1,AluResult2:  STD_LOGIC_VECTOR(wordSize-1 DOWNTO 0);  ------- the forwarding from Ex|mem buffer 
    Signal WbValue1,WbValue2:  STD_LOGIC_VECTOR(wordSize-1 DOWNTO 0);    ----- the forwarding from mem/Wb buffer

    -----------------------------------------------------
    -----------------------------------------------------

    -- notes -----------

    -- 1- priority is for ex\mem forwarding so it is the first condition in if else statement 
    -- 2- we have assumed no two instructions in the same batch will write back in the same register 
    --     but make the second issue have the higer priority 
     
      ------------       |3|  |   |1|
      -----------        |4|  |   |2|          4 is the highest priotity

BEGIN
----------- SIGNAL MAPPING From Buffers 

    IdEXRsc1 <= IDEXBuffer (IDEXRsrc1E downto IDEXRsrc1S ) ;
    IdEXRdst1 <= IDEXBuffer (IDEXRdst1E downto IDEXRdst1S ) ;
    IdEXRsc2 <= IDEXBuffer ( IDEXRsrc2E downto IDEXRsrc2S) ;
    IdEXRdst2 <= IDEXBuffer (IDEXRdst2E downto IDEXRdst2S ) ;
    RSrc1Value <= IDEXBuffer (IDEXRsrc1ValueE downto IDEXRsrc1ValueS ) ;
    RDst1Value <= IDEXBuffer (IDEXRdst1ValueE downto IDEXRdst1ValueS ) ;
    RSrc2Value <= IDEXBuffer (IDEXRsrc2ValueE downto IDEXRsrc2ValueS ) ;
    RDst2Value <= IDEXBuffer (IDEXRdst2ValueE downto IDEXRdst2ValueS ) ;
    noForwarding1 <=IDEXBuffer(IDEXIsNoForward1);
    noForwarding2 <=IDEXBuffer(IDEXIsNoForward2);


    ExMemRdst1 <= EXMEMBuffer (EXMEMRdst1E downto EXMEMRdst1S ) ;
    ExMemRdst2 <= EXMEMBuffer (EXMEMRdst2E downto EXMEMRdst2S ) ;
    ExMemWriteback1 <= EXMEMBuffer ( EXMEMWB1 ) ;
    ExMemWriteback2 <= EXMEMBuffer ( EXMEMWB2 ) ;
    AluResult1 <= EXMEMBuffer (EXMEMResult1E downto EXMEMResult1S ) ;
    AluResult2 <= EXMEMBuffer (EXMEMResult2E downto EXMEMResult2S ) ;


    MemWbRdst1 <= MEMWBBuffer (MEMWBRdst1E downto MEMWBRdst1S ) ;
    MemWbRdst2 <= MEMWBBuffer (MEMWBRdst2E downto MEMWBRdst2S ) ;
    MemWbWriteback1 <= MEMWBBuffer ( MEMWBWB1 ) ;
    MemWbWriteback2 <= MEMWBBuffer ( MEMWBWB2 ) ;
    WbValue1 <= MEMWBBuffer (MEMWBWriteBackValue1E downto MEMWBWriteBackValue1S ) ;
    WbValue2 <= MEMWBBuffer (MEMWBWriteBackValue2E downto MEMWBWriteBackValue2S ) ;

    ----------------------------------------------------------
    process (noForwarding1,IdEXRsc1,ExMemRdst1,ExMemRdst2,ExMemWriteback1,ExMemWriteback2,MemWbRdst1,MemWbRdst2,MemWbWriteback1,MemWbWriteback2,AluResult2,AluResult1,WbValue2,WbValue1,RSrc1Value)
        begin 
            if (noForwarding1='1') then
                Src1 <= RSrc1Value;
            elsif ((ExMemWriteback2='1') and (ExMemRdst2 =IdEXRsc1) ) then 
                Src1 <= AluResult2;
            elsif ((ExMemWriteback1='1') and (ExMemRdst1 =IdEXRsc1) ) then 
                Src1 <= AluResult1;
            elsif (MemWbWriteback2='1' and (MemWbRdst2 =IdEXRsc1) ) then 
                Src1 <= WbValue2;
            elsif (MemWbWriteback1='1' and (MemWbRdst1 =IdEXRsc1) ) then 
                Src1 <= WbValue1;
            else 
                Src1 <= RSrc1Value;
            end if;
            
        end process;
    ----------------------------------------------------------------------

    ----------------------------------------------------------
    process (noForwarding1,IdEXRdst1,ExMemRdst1,ExMemRdst2,ExMemWriteback1,ExMemWriteback2,MemWbRdst1,MemWbRdst2,MemWbWriteback1,MemWbWriteback2,AluResult2,AluResult1,WbValue2,WbValue1,RDst1Value)
        begin 
            if (noForwarding1='1') then
                Dst1 <= RDst1Value;
            elsif (ExMemWriteback2='1' and (ExMemRdst2 =IdEXRdst1) ) then 
                Dst1 <= AluResult2;
            elsif (ExMemWriteback1='1' and (ExMemRdst1 =IdEXRdst1) ) then 
                Dst1 <= AluResult1;
            elsif (MemWbWriteback2='1' and (MemWbRdst2 =IdEXRdst1) ) then 
                Dst1 <= WbValue2;
            elsif (MemWbWriteback1='1'and (MemWbRdst1 =IdEXRdst1) ) then 
                Dst1 <= WbValue1;
            else 
                Dst1 <= RDst1Value;
            end if;

            
        end process;
    ----------------------------------------------------------------------

  ----------------------------------------------------------
    process (noForwarding2,IdEXRsc2,ExMemRdst1,ExMemRdst2,ExMemWriteback1,ExMemWriteback2,MemWbRdst1,MemWbRdst2,MemWbWriteback1,MemWbWriteback2,AluResult2,AluResult1,WbValue2,WbValue1,RSrc2Value)
        begin
            if (noForwarding2='1') then
                Src2 <= RSrc2Value; 
            elsif (ExMemWriteback2='1' and (ExMemRdst2 =IdEXRsc2) ) then 
                Src2 <= AluResult2;
            elsif (ExMemWriteback1='1' and (ExMemRdst1 =IdEXRsc2) ) then 
                Src2 <= AluResult1;
            elsif (MemWbWriteback2='1' and (MemWbRdst2 =IdEXRsc2) ) then 
                Src2 <= WbValue2;
            elsif (MemWbWriteback1='1' and (MemWbRdst1 =IdEXRsc2) ) then 
                Src2 <= WbValue1;
            else 
                Src2 <= RSrc2Value;
            end if;

            
        end process;
    ----------------------------------------------------------------------


    ----------------------------------------------------------
    process (noForwarding2,IdEXRdst2,ExMemRdst1,ExMemRdst2,ExMemWriteback1,ExMemWriteback2,MemWbRdst1,MemWbRdst2,MemWbWriteback1,MemWbWriteback2,AluResult2,AluResult1,WbValue2,WbValue1,RDst2Value)
        begin 
            if (noForwarding2='1') then
                Dst2 <= RDst2Value;
            elsif (ExMemWriteback2='1' and (ExMemRdst2 =IdEXRdst2) ) then 
                Dst2 <= AluResult2;
            elsif (ExMemWriteback1='1' and (ExMemRdst1 =IdEXRdst2) ) then 
                Dst2 <= AluResult1;
            elsif (MemWbWriteback2='1' and (MemWbRdst2 =IdEXRdst2) ) then 
                Dst2 <= WbValue2;
            elsif (MemWbWriteback1='1' and (MemWbRdst1 =IdEXRdst2) ) then 
                Dst2 <= WbValue1;
            else 
                Dst2 <= RDst2Value;  
             end if;

        end process;
    ---------------------------------------------------------------------
    
    

END ARCHITECTURE;