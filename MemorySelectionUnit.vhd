Library IEEE;
use ieee.std_logic_1164.all;
use work.constants.all;

-- MemorySelectionUnit Entity

ENTITY MemorySelectionUnit IS
      Generic(wordSize:integer :=16);
	PORT(
            IDEXBuffer: in STD_LOGIC_VECTOR(IDEXLength DOWNTO 0);
            EXMEMBuffer: out STD_LOGIC_VECTOR(EXMEMLength DOWNTO 0);
            Rsrc1,Rdst1,Rsrc2,Rdst2 :in STD_LOGIC_VECTOR(wordSize-1 downto 0)  -- we must use the values after forwarding 
		);

END ENTITY MemorySelectionUnit;

----------------------------------------------------------------------
-- MemorySelectionUnitister Architecture

ARCHITECTURE MemorySelectionUnitArch of MemorySelectionUnit is
SIGNAL  mw1,mw2,mr1,mr2,skop1,skop2 : STD_LOGIC; ---     form IDEXbuffer ;

SIGNAL  mw,mr,skop,which : STD_LOGIC;      -----   value the will be saved in EXMEMBuffer;
SIGNAL RsrcMemory,RdstMemory : STD_LOGIC_VECTOR (wordSize-1 downto 0);

------------- important---------- assume that no two instruction will access memry in the same batch
----------------- this circuit output depent on decoding output
BEGIN
      --------------- SIGNAL MAPPING 

      mw1 <= IDEXBuffer (IDEXMW1);
      mr1 <= IDEXBuffer (IDEXMR1);
      skop1 <= IDEXBuffer (IDEXStackOperation1);

      mw2 <= IDEXBuffer (IDEXMW2);
      mr2 <= IDEXBuffer (IDEXMR2);
      skop2 <= IDEXBuffer (IDEXStackOperation2);

      EXMEMBuffer (EXMEMMW) <= mw;
      EXMEMBuffer (EXMEMMR) <= mr;
      EXMEMBuffer (EXMEMStackOperation) <= skop;
      EXMEMBuffer (EXMEMWHICINSTR) <= which;
      EXMEMBuffer ( EXMEMRsrcValFRWE downto EXMEMRsrcValFRWS) <= RsrcMemory;
      EXMEMBuffer ( EXMEMRdstValFRWE downto EXMEMRdstValFRWS) <= RdstMemory;


      ---------------------------------------------------
      process (mw1,mw2,mr1,mr2,skop1,skop2,Rsrc1,Rdst1,Rsrc2,Rdst2)
            begin 
                  if (skop1='1' or mw1='1' or mr1='1') then 
                        skop<= skop1;
                        mr <= mr1;
                        mw <= mw1;
                        RsrcMemory <= Rsrc1;
                        RdstMemory <= Rdst1;
                        which <= '0' ;       --------------- for shehab 
                  elsif (skop2='1' or mw2='1' or mr2='1') then 
                        skop<= skop2;
                        mr <= mr2;
                        mw <= mw2;
                        RsrcMemory <= Rsrc2;
                        RdstMemory <= Rdst2;
                        which <= '1' ;       --------------- for shehab 
                  else 
                       skop <= '0';
                       mr <= '0';
                       mw <= '0';
                       which <='0';     
                       RsrcMemory <= (others => '0');   ----- any value not importnat 
                       RdstMemory <= (others => '0') ;  ----- any value not importnat 
                  end if;
      end process;

END ARCHITECTURE;