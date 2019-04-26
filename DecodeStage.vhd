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
            clk, rst: in STD_LOGIC;
            INPort: in STD_LOGIC_VECTOR(n-1 DOWNTO 0);
            IDEXBuffer: out STD_LOGIC_VECTOR(IDEXLength DOWNTO 0);
            PcIncrement : out STD_LOGIC_VECTOR(1 downto 0)
		);

END ENTITY DecodeStage;

----------------------------------------------------------------------
-- DecodeStageister Architecture

ARCHITECTURE DecodeStageArch of DecodeStage is
    signal isIN1, isIN2, isLDM1, isLDM2, isLDMLastOne: STD_LOGIC;
    signal busSrc1, busDst1, busSrc2, busDst2: std_logic_vector(n-1 downto 0);
    signal preIDEXBuffer: STD_LOGIC_VECTOR(IDEXLength DOWNTO 0);

BEGIN


    controlUnitEnt : entity work.controlUnit port map(
        Instruction1 => IFIDbuffer(IFIDInstruction1E downto IFIDInstruction1S),
        Instruction2 => IFIDbuffer(IFIDInstruction2E downto IFIDInstruction2S),
        IDEXBuffer => preIDEXBuffer,
        AddedToPc =>  PcIncrement,
        isIN1 => isIN1,
        isIN2 => isIN2,
        isLDM1 => isLDM1,
        isLDM2 => isLDM2
    );
    
    regFileEnt: entity work.GenenralPurposeRegFile generic map(16,8) port map(
        busSrc1 => preIDEXBuffer(IDEXRsrc1ValueE downto IDEXRsrc1ValueS),
        busDst1 => busDst1,
        busSrc2 => preIDEXBuffer(IDEXRsrc2ValueE downto IDEXRsrc2ValueS),
        busDst2 => busDst2,
        busRes1 => MEMWBbuffer(MEMWBWriteBackValue1E downto MEMWBWriteBackValue1S),
        busRes2 => MEMWBbuffer(MEMWBWriteBackValue2E downto MEMWBWriteBackValue2S),
        WB1 => MEMWBbuffer(MEMWBWB1),
        WB2 => MEMWBbuffer(MEMWBWB2),
        ResetRegs => rst,
        clk => clk,
        src1 => preIDEXBuffer(IFIDRscr1E downto IFIDRscr1S),
        dst1 => preIDEXBuffer(IFIDRdst1E downto IFIDRdst1S),
        src2 => preIDEXBuffer(IFIDRscr2E downto IFIDRscr2S),
        dst2 => preIDEXBuffer(IFIDRdst2E downto IFIDRdst2S),
        WBdst1 => MEMWBbuffer(EXMEMRdst1E downto EXMEMRdst1S),
        WBdst2 => MEMWBbuffer(EXMEMRdst2E downto EXMEMRdst2S)
    );

    preIDEXBuffer(IDEXPCE downto IDEXPCS) <= IFIDbuffer(IFIDPCE downto IFIDPCS);

    preIDEXBuffer(IDEXRdst1ValueE downto IDEXRdst1ValueS) <=  INPort when isIN1 = '1'
            else IFIDbuffer(IFIDInstruction2E downto IFIDInstruction2S) when isLDM1 = '1'
            else busDst1; 

    preIDEXBuffer(IDEXRdst2ValueE downto IDEXRdst2ValueS) <=  INPort when isIN2 = '1'
            else beforeIFIDbuffer(IFIDInstruction1E downto IFIDInstruction1S) when isLDM2 = '1'
            else busDst2; 

    IDEXBuffer(IDEXInc1E downto IDEXInc1S) <= (Others => '0') when isLDMLastOne = '1'
                else preIDEXBuffer(IDEXInc1E downto IDEXInc1S);
    IDEXBuffer(IDEXInc2E downto IDEXInc2S) <= (Others => '0') when isLDM1 = '1'
                else preIDEXBuffer(IDEXInc2E downto IDEXInc2S);
    IDEXBuffer(IDEXLength downto IDEXInc2E+1) <= preIDEXBuffer(IDEXLength downto IDEXInc2E+1);

    process(clk)
    begin
        if clk'event and clk = '1' then
            isLDMLastOne <= isLDM2;
        end if;
    end process;


END ARCHITECTURE;