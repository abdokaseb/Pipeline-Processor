Library IEEE;
use ieee.std_logic_1164.all;
use work.constants.all;

-- DecodeStage Entity

ENTITY DecodeStage IS
	PORT(
            IFIDbuffer: in STD_LOGIC_VECTOR(IFIDLength DOWNTO 0);
            MEMWBbuffer: in STD_LOGIC_VECTOR(MEMWBLength DOWNTO 0);
			clk, rst: in STD_LOGIC;
            IDEXBuffer: out STD_LOGIC_VECTOR(IDEXLength DOWNTO 0)
		);

END ENTITY DecodeStage;

----------------------------------------------------------------------
-- DecodeStageister Architecture

ARCHITECTURE DecodeStageArch of DecodeStage is

BEGIN


    controlUnitEnt : entity work.controlUnit port map(
        Instruction1 => IFIDbuffer(IFIDInstruction1E downto IFIDInstruction1S),
        Instruction2 => IFIDbuffer(IFIDInstruction2E downto IFIDInstruction2S),
        IDEXBuffer => IDEXBuffer       
    );
    
    regFileEnt: entity work.GenenralPurposeRegFile generic map(16,8) port map(
        busSrc1 => IDEXBuffer(IDEXRsrc1ValueE downto IDEXRsrc1ValueS),
        busDst1 => IDEXBuffer(IDEXRdst1ValueE downto IDEXRdst1ValueS),
        busSrc2 => IDEXBuffer(IDEXRsrc2ValueE downto IDEXRsrc2ValueS),
        busDst2 => IDEXBuffer(IDEXRdst2ValueE downto IDEXRdst2ValueS),
        busRes1 => MEMWBbuffer(MEMWBWriteBackValue1E downto MEMWBWriteBackValue1S),
        busRes2 => MEMWBbuffer(MEMWBWriteBackValue2E downto MEMWBWriteBackValue2S),
        WB1 => MEMWBbuffer(MEMWBWB1),
        WB2 => MEMWBbuffer(MEMWBWB2),
        ResetRegs => rst,
        clk => clk,
        src1 => IDEXBuffer(IFIDRscr1E downto IFIDRscr1E),
        dst1 => IDEXBuffer(IFIDRdst1E downto IFIDRdst1E),
        src2 => IDEXBuffer(IFIDRscr2E downto IFIDRscr2E),
        dst2 => IDEXBuffer(IFIDRdst2E downto IFIDRdst2E),
        WBdst1 => MEMWBbuffer(EXMEMRdst1E downto EXMEMRdst1S),
        WBdst2 => MEMWBbuffer(EXMEMRdst2E downto EXMEMRdst2S)
    );

    IDEXBuffer(IDEXPCE downto IDEXPCS) <= IFIDbuffer(IFIDPCE downto IFIDPCS);


END ARCHITECTURE;