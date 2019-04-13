LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.math_real.all;
USE IEEE.numeric_std.all;

entity GenenralPurposeRegFile is

    generic(n: integer := 16;
            numRegs: integer := 8);

    port(busSrc1, busDst1,busSrc2,busDst2: out std_logic_vector(n-1 downto 0);
        busRes1, busRes2: in std_logic_vector(n-1 downto 0);
        WB1, WB2, ResetRegs, clk:in std_logic; 
        src1, dst1, src2, dst2,WBdst1,WBdst2:in std_logic_vector(integer(log2(real(numRegs))) - 1 downto 0));

end GenenralPurposeRegFile;


architecture GenenralPurposeRegFileArch of GenenralPurposeRegFile is

    TYPE outRegsType IS ARRAY (0 TO numRegs - 1) OF std_logic_vector(n-1 DOWNTO 0);

    signal outDecoderSrc1, outDecoderDst1, outDecoderSrc2, outDecoderDst2, outDecoderWBDst1, outDecoderWBDst2, enableWB: std_logic_vector (numRegs-1 downto 0);
    signal outRegisters, inRegisters: outRegsType;  
    signal one, notClk :std_logic;

    begin
        notClk <= not clk;
        one <= '1';
        decSrc1 : entity work.decoder generic map(integer(log2(real(numRegs)))) port map (src1,one,outDecoderSrc1);
        decDst1 : entity work.decoder generic map(integer(log2(real(numRegs)))) port map (dst1,one,outDecoderDst1);
        decSrc2 : entity work.decoder generic map(integer(log2(real(numRegs)))) port map (src2,one,outDecoderSrc2);
        decDst2 : entity work.decoder generic map(integer(log2(real(numRegs)))) port map (dst2,one,outDecoderDst2);

        decWBDst1 : entity work.decoder generic map(integer(log2(real(numRegs)))) port map (WBdst1, WB1, outDecoderWBDst1);
        decWBDst2 : entity work.decoder generic map(integer(log2(real(numRegs)))) port map (WBdst2, WB2, outDecoderWBDst2);

        enableWB <= outDecoderWBDst1 OR outDecoderWBDst2;

        loopGenerateRegs: for i in 0 to numRegs-1 generate
            triSrc1 : entity work.Tristate generic map(n) port map (outRegisters(i), outDecoderSrc1(i), busSrc1);
            triDst1 : entity work.Tristate generic map(n) port map (outRegisters(i), outDecoderDst1(i), busDst1);
            triSrc2 : entity work.Tristate generic map(n) port map (outRegisters(i), outDecoderSrc2(i), busSrc2);
            triDst2 : entity work.Tristate generic map(n) port map (outRegisters(i), outDecoderDst2(i), busDst2);
            
            MuxInputReg : entity work.Mux2 generic map(n) port map (busRes1, busRes2, outDecoderWBDst2(i)  ,inRegisters(i));
            Reg : entity work.Reg generic map(n) port map (inRegisters(i), enableWB(i), notClk, ResetRegs, outRegisters(i));
        end generate;

end architecture;