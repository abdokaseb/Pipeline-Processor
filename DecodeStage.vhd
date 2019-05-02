Library IEEE;
use ieee.std_logic_1164.all;
use work.constants.all;

-- DecodeStage Entity

ENTITY DecodeStage IS
    generic(n: integer := 16);
	PORT(
            IFIDbuffer: in STD_LOGIC_VECTOR(IFIDLength DOWNTO 0);
            beforeIFIDbuffer: in STD_LOGIC_VECTOR(IFIDLength DOWNTO 0);
            MEMWBbuffer: in STD_LOGIC_VECTOR(MEMWBLength DOWNTO 0);
            clk, rst, interruptSignal, resetSignal: in STD_LOGIC;
            INPort: in STD_LOGIC_VECTOR(n-1 DOWNTO 0);
            IDEXBuffer: out STD_LOGIC_VECTOR(IDEXLength DOWNTO 0);
            PcIncrement : out STD_LOGIC_VECTOR(1 downto 0);
            isLDM: out STD_LOGIC
		);

END ENTITY DecodeStage;

----------------------------------------------------------------------
-- DecodeStageister Architecture

ARCHITECTURE DecodeStageArch of DecodeStage is
    signal isIN1, isIN2, isLDM1, isLDM2, isLDMLastOne,interruptSignalLastOne: STD_LOGIC;
    signal busSrc1, busDst1, busSrc2, busDst2: std_logic_vector(n-1 downto 0);
    signal preIDEXBuffer: STD_LOGIC_VECTOR(IDEXLength DOWNTO 0);

BEGIN


    controlUnitEnt : entity work.controlUnit port map(
        Instruction1 => IFIDbuffer(IFIDInstruction1E downto IFIDInstruction1S),
        Instruction2 => IFIDbuffer(IFIDInstruction2E downto IFIDInstruction2S),
        IDEXBuffer => preIDEXBuffer,
        AddedToPcSignal =>  PcIncrement,
        isIN1 => isIN1,
        isIN2 => isIN2,
        isLDM1 => isLDM1,
        isLDM2 => isLDM2,
        IFIDbuffer=>IFIDbuffer,
        clk =>clk,
        rst =>rst
    );
    
    regFileEnt: entity work.GenenralPurposeRegFile generic map(16,8) port map(
        busSrc1 => busSrc1,
        busDst1 => preIDEXBuffer(IDEXRdst1ValueE downto IDEXRdst1ValueS),
        busSrc2 => busSrc2,
        busDst2 => preIDEXBuffer(IDEXRdst2ValueE downto IDEXRdst2ValueS),
        busRes1 => MEMWBbuffer(MEMWBWriteBackValue1E downto MEMWBWriteBackValue1S),
        busRes2 => MEMWBbuffer(MEMWBWriteBackValue2E downto MEMWBWriteBackValue2S),
        WB1 => MEMWBbuffer(MEMWBWB1),
        WB2 => MEMWBbuffer(MEMWBWB2),
        ResetRegs => rst,
        clk => clk,
        src1 => preIDEXBuffer(IDEXRsrc1E downto IDEXRsrc1S),
        dst1 => preIDEXBuffer(IDEXRdst1E downto IDEXRdst1S),
        src2 => preIDEXBuffer(IDEXRsrc2E downto IDEXRsrc2S),
        dst2 => preIDEXBuffer(IDEXRdst2E downto IDEXRdst2S),
        WBdst1 => MEMWBbuffer(EXMEMRdst1E downto EXMEMRdst1S),
        WBdst2 => MEMWBbuffer(EXMEMRdst2E downto EXMEMRdst2S)
    );
                
    preIDEXBuffer(IDEXRsrc1E downto IDEXRsrc1S) <= IFIDbuffer(IFIDRsrc1E downto IFIDRsrc1S);
    preIDEXBuffer(IDEXRdst1E downto IDEXRdst1S) <= IFIDbuffer(IFIDRdst1E downto IFIDRdst1S);
    preIDEXBuffer(IDEXRsrc2E downto IDEXRsrc2S) <= IFIDbuffer(IFIDRsrc2E downto IFIDRsrc2S);
    preIDEXBuffer(IDEXRdst2E downto IDEXRdst2S) <= IFIDbuffer(IFIDRdst2E downto IFIDRdst2S);

    preIDEXBuffer(IDEXPCE downto IDEXPCS) <= IFIDbuffer(IFIDPCE downto IFIDPCS);

    preIDEXBuffer(IDEXRsrc1ValueE downto IDEXRsrc1ValueS) <=  INPort when isIN1 = '1'
            else IFIDbuffer(IFIDInstruction2E downto IFIDInstruction2S) when isLDM1 = '1'
            else busSrc1; 

    preIDEXBuffer(IDEXRsrc2ValueE downto IDEXRsrc2ValueS) <=  INPort when isIN2 = '1'
            else beforeIFIDbuffer(IFIDInstruction1E downto IFIDInstruction1S) when isLDM2 = '1'
            else busSrc2; 

    preIDEXBuffer(IDEXISINT) <= interruptSignalLastOne;
    process(clk)
    begin
        if clk'event and clk = '1' then
            interruptSignalLastOne <= interruptSignal;
        end if;
    end process;
    preIDEXBuffer(IDEXisReset) <= resetSignal;
    preIDEXBuffer(IDEXInc2E downto IDEXFreeInc2S) <= (Others => '0');
    preIDEXBuffer(IDEXInc1E downto IDEXFreeInc1S) <= (Others => '0');
    
    IDEXBuffer(IDEXInc1E downto IDEXInc1S) <= (Others => '0') when isLDMLastOne = '1'
                                                                or PcIncrement = "00"
                                                                or interruptSignalLastOne = '1'
                else preIDEXBuffer(IDEXInc1E downto IDEXInc1S);
    IDEXBuffer(IDEXInc2E downto IDEXInc2S) <= (Others => '0') when isLDM1 = '1'
                                                                or PcIncrement = "00"
                                                                or PcIncrement = "01"
                                                                or interruptSignalLastOne = '1'
                else preIDEXBuffer(IDEXInc2E downto IDEXInc2S);
    IDEXBuffer(IDEXLength downto IDEXInc2E+1) <= preIDEXBuffer(IDEXLength downto IDEXInc2E+1);

    isLDM <= isLDM2;
    process(clk)
    begin
        if clk'event and clk = '1' then
            isLDMLastOne <= isLDM2;
        end if;
    end process;


    -- TO ASK 
    preIDEXBuffer(IDEXDSB2E downto IDEXDSB2S) <= (Others=>'0');
    preIDEXBuffer(IDEXDSB1E downto IDEXDSB1S) <= (Others=>'0');
    preIDEXBuffer(IDEXWriteTwowords1) <= '0';
    preIDEXBuffer(IDEXWriteTwowords2) <= '0';


END ARCHITECTURE;