Library IEEE;
use ieee.std_logic_1164.all;
use work.constants.all;
use ieee.numeric_std.all;

-- CalcRamParamsUnit Entity

ENTITY CalcRamParamsUnit IS
    GENERIC (addressSize :INTEGER := RAMaddressBits);
    PORT(
        EXMEMbuffer: IN STD_LOGIC_VECTOR(EXMEMLength DOWNTO 0);
        clk,rst : IN STD_LOGIC;
        addressToMem : OUT STD_LOGIC_VECTOR(addressSize - 1 DOWNTO 0);
        dataToMem1,dataToMem2  : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        MemRead,MemWrite,twoWordsReadOrWrite,PCWBPOPLD,FLAGSWBPOP,keepFlushing: OUT STD_LOGIC 
        -- MemRead is n't important for memory but for mux 
        -- PCWBPOPLD write in pc value from memory due to pop like RET or due to load like INT
    );

END ENTITY CalcRamParamsUnit;

----------------------------------------------------------------------
-- CalcRamParamsUnit Architecture

ARCHITECTURE CalcRamParamsUnitArch OF CalcRamParamsUnit IS
    SIGNAL DSB : STD_LOGIC_VECTOR (1 DOWNTO 0);
    SIGNAL PC : STD_LOGIC_VECTOR (PCLength-1 DOWNTO 0);
    SIGNAL FLAGS,FlagsLatch : STD_LOGIC_VECTOR (flagsCount-1 DOWNTO 0);
    SIGNAL isStackOper,isINT,MR,MW,whichInstr: STD_LOGIC;
    ------------------
    SIGNAL SPRegOut,SPRegIn,tmpPC,tmpSP : STD_LOGIC_VECTOR(PCLength-1 DOWNTO 0);
    SIGNAL RsrcVal,RdstVal : STD_LOGIC_VECTOR(15 DOWNTO 0);
    
    -------------- State Machines -----------
    TYPE INT_State_type IS (pushPC,pushFlags,readNewPC); -- INT state machine
    SIGNAL INTstate : INT_State_type;
    TYPE RTI_State_type IS (popFlags,popPC); -- RTI state machine
    SIGNAL RTIstate : RTI_State_type;

BEGIN
    RsrcVal <= EXMEMbuffer(EXMEMRsrcValFRWE DOWNTO EXMEMRsrcValFRWS);
    RdstVal <= EXMEMbuffer(EXMEMRdstValFRWE DOWNTO EXMEMRdstValFRWS);
    DSB <= EXMEMbuffer(EXMEMDSBE DOWNTO EXMEMDSBS);
    PC <= EXMEMbuffer(EXMEMPCE DOWNTO EXMEMPCS);
    FLAGS <= EXMEMbuffer(EXMEMFLAGSE DOWNTO EXMEMFLAGSS);
    isStackOper <= EXMEMbuffer(EXMEMStackOperation);
    isINT <= EXMEMbuffer(EXMEMISINT);
    MW <= EXMEMbuffer(EXMEMMW);
    MR <= EXMEMbuffer(EXMEMMR);
    whichInstr <= EXMEMbuffer(EXMEMWHICINSTR);

    STACKPINTERREG : ENTITY work.SP generic map(SPLength) port map(SPRegIn,VCC,clk,rst,SPRegOut);

    PROCESS (RsrcVal, RdstVal, DSB, PC, FLAGS, MW, MR, isStackOper, isINT, INTstate, RTIstate,SPRegIn,tmpPC,whichInstr)
    BEGIN
        if isINT = '1' OR INTstate /= pushPC then --or DSB = OpCodeRTIDSB or RTIstate != popFlags) -- STALL OR PC + 0 ???
            CASE INTstate IS
                when pushPC =>
                    PCWBPOPLD <= '0';
                    FLAGSWBPOP <= '0';
                    keepFlushing <= '1';
                    twoWordsReadOrWrite <= '1';
                    SPRegIn <= std_logic_vector( unsigned(SPRegOut) - 2);
                    MemRead <= '0';
                    MemWrite <= '1';
                    addressToMem <= SPRegOut(addressSize-1 DOWNTO 0 ); 
                    dataToMem1 <= PC(31 DOWNTO 16);
                    dataToMem2 <= PC(15 DOWNTO 0);                    
                when pushFlags =>
                    PCWBPOPLD <= '0';
                    FLAGSWBPOP <= '0';
                    keepFlushing <= '1';
                    twoWordsReadOrWrite <= '0';
                    SPRegIn <= std_logic_vector( unsigned(SPRegOut) - 1);
                    MemRead <= '0';
                    MemWrite <= '1';
                    addressToMem <= SPRegOut(addressSize-1 DOWNTO 0 ); 
                    dataToMem1(flagsCount -1 downto 0) <= FlagsLatch; -- latch flags during first state
                    dataToMem2 <= (OTHERS => '0');
                when readNewPC =>
                    PCWBPOPLD <= '1'; 
                    FLAGSWBPOP <= '0';
                    keepFlushing <= '0';
                    twoWordsReadOrWrite <= '1';
                    SPRegIn <= SPRegOut;
                    MemRead <= '1';
                    MemWrite <= '0';
                    addressToMem <= STD_LOGIC_VECTOR(to_unsigned(DefaultIntAddress,addressSize));
                    dataToMem1 <= (OTHERS => '0');
                    dataToMem2 <= (OTHERS => '0'); 
            END CASE;             
        elsif (DSB = OpCodeRTIDSB) or (RTIstate /= popFlags) then
            CASE RTIstate IS
                when popFlags =>
                    PCWBPOPLD <= '0';
                    FLAGSWBPOP <= '1';
                    keepFlushing <= '1';
                    twoWordsReadOrWrite <= '0';
                    SPRegIn <= std_logic_vector( unsigned(SPRegOut) + 1 );
                    MemRead <= '1';
                    MemWrite <= '0';
                    addressToMem <= SPRegIn(addressSize-1 DOWNTO 0 ); 
                    dataToMem1 <= (OTHERS => '0');
                    dataToMem2 <= (OTHERS => '0');  
                when popPC =>
                    PCWBPOPLD <= '1';
                    FLAGSWBPOP <= '0';
                    keepFlushing <= '0';
                    twoWordsReadOrWrite <= '1';
                    SPRegIn <= std_logic_vector( unsigned(SPRegOut) + 2);
                    MemRead <= '1';
                    MemWrite <= '0';
                    addressToMem <= SPRegIn(addressSize-1 DOWNTO 0 ); 
                    dataToMem1(flagsCount -1 downto 0) <= FLAGS;
                    dataToMem2 <= (OTHERS => '0');
            END CASE;
        elsif DSB = OpCodeNODSB then
            PCWBPOPLD <= '0';
            FLAGSWBPOP <= '0';
            keepFlushing <= '0';
            twoWordsReadOrWrite <= '0';
            if isStackOper = '1' then
                if MR = '1' then
                    SPRegIn <= std_logic_vector( unsigned(SPRegOut) + 1 );
                    MemRead <= '1';
                    MemWrite <= '0';
                    addressToMem <= SPRegIn(addressSize-1 DOWNTO 0 ); 
                    dataToMem1 <= (OTHERS => '0');
                    dataToMem2 <= (OTHERS => '0');  
                elsif MW = '1' then
                    SPRegIn <= std_logic_vector( unsigned(SPRegOut) - 1 );
                    MemRead <= '0';
                    MemWrite <= '1';
                    addressToMem <= SPRegOut(addressSize-1 DOWNTO 0 ); 
                    dataToMem1 <= RdstVal;
                    dataToMem2 <= (OTHERS => '0'); -- useless
                else
                    SPRegIn <= SPRegOut;
                    MemRead <= '0';
                    MemWrite <= '0';
                    addressToMem <= (OTHERS => '0');
                    dataToMem1 <= (OTHERS => '0');
                    dataToMem2 <= (OTHERS => '0');
                end if ;
            else
                SPRegIn <= SPRegOut;
                if MR ='1' then
                    MemRead <= '1';
                    MemWrite <= '0';
                    addressToMem <= std_logic_vector(resize(unsigned(RsrcVal), addressSize));
                    dataToMem1 <= (OTHERS => '0');
                    dataToMem2 <= (OTHERS => '0');
                elsif MW = '1' then
                    MemRead <= '0';
                    MemWrite <= '1';
                    addressToMem <= std_logic_vector(resize(unsigned(RdstVal), addressSize));
                    dataToMem1 <= RsrcVal;
                    dataToMem2 <= RsrcVal;
                else
                    MemRead <= '0';
                    MemWrite <= '0';
                    addressToMem <= (OTHERS => '0');
                    dataToMem1 <= (OTHERS => '0');
                    dataToMem2 <= (OTHERS => '0');
                end if;
            end if;
        elsif DSB = OpCodeRETDSB then
            PCWBPOPLD <= '1';
            FLAGSWBPOP <= '0';
            keepFlushing <= '0';
            twoWordsReadOrWrite <= '1';
            SPRegIn <= std_logic_vector( unsigned(SPRegOut) + 2 );
            MemRead <= '1';
            MemWrite <= '0';
            addressToMem <= SPRegIn(addressSize-1 DOWNTO 0 ); 
            dataToMem1 <= (OTHERS => '0');
            dataToMem2 <= (OTHERS => '0'); 
        elsif DSB = OpCodeCALLDSB then 
            PCWBPOPLD <= '0';
            FLAGSWBPOP <= '0';
            keepFlushing <= '0';
            twoWordsReadOrWrite <= '1';
            SPRegIn <= std_logic_vector( unsigned(SPRegOut) - 2 ); 
            MemRead <= '1';
            MemWrite <= '0';
            addressToMem <= SPRegOut(addressSize-1 DOWNTO 0 );
            if (whichInstr ='0') then
                tmpPc <= std_logic_vector( unsigned(PC) + 1 );
                dataToMem2 <= tmpPc(15 DOWNTO 0);
                dataToMem1 <= tmpPc(31 DOWNTO 16);
            else
                tmpPc <= std_logic_vector( unsigned(PC) + 2 );
                dataToMem2 <= tmpPc(15 DOWNTO 0);
                dataToMem1 <= tmpPc(31 DOWNTO 16);  
            end if;
        else -- confilict or undifined may be use for debuging
            keepFlushing <= '0';
            PCWBPOPLD <= '0';
            FLAGSWBPOP <= '0';
            twoWordsReadOrWrite <= '0';
            SPRegIn <= SPRegOut;
            MemRead <= '0';
            MemWrite <= '0';
            addressToMem <= (OTHERS => '0');
            dataToMem1 <= (OTHERS => '0');
            dataToMem2 <= (OTHERS => '0'); 
        end if;
    END PROCESS;

--------------------------------------------------------- INT STATE MACHINE --------------------------------------------

    PROCESS (rst,clk) 
    BEGIN
        if rst = '1' or (isINT = '0' and INTstate = pushPC) then -- STALL OR PC + 0 ??? i am assuming PC + 0
            INTstate <= pushPC;  
        else -- INT STATE MACHINE
            if rising_edge(clk) then
                CASE INTstate IS
                    when pushPC =>
                        INTstate <= pushFlags; 
                        FlagsLatch <= Flags; -- latch flags for next state (pushFlags) as buffer is moving                      
                    when pushFlags =>
                        INTstate <= readNewPC;
                    when readNewPC =>
                        INTstate <= pushPC;
                END CASE;
            end if;
        end if;
    END PROCESS;

--------------------------------------------------------- RTI STATE MACHINE --------------------------------------------

    PROCESS (rst,clk) 
    BEGIN
        if rst = '1' or (DSB /=  OpCodeRTIDSB and RTIstate = popFlags) then -- STALL OR PC + 0 ??? i am assuming PC + 0
            RTIstate <= popFlags;  
        else -- RTI STATE MACHINE
            if rising_edge(clk) then
                CASE RTIstate IS
                    when popFlags =>
                        RTIstate <= popPC;                              
                    when popPC =>
                        RTIstate <= popFlags;
                END CASE;
            end if;
        end if;
    END PROCESS;

END ARCHITECTURE;