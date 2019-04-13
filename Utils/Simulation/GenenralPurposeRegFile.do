# busRes1 \
# busRes2 \
# clk \
# dst1 \
# dst2 \
# n \
# numRegs \
# ResetRegs \
# src1 \
# src2 \
# WB1 \
# WB2 \
# WBdst1 \
# WBdst2 \
# busDst1 \
# busDst2 \
# busSrc1 \
# busSrc2 \
# enableWB \
# inRegisters \
# one \
# outDecoderDst1 \
# outDecoderDst2 \
# outDecoderSrc1 \
# outDecoderSrc2 \
# outDecoderWBDst1 \
# outDecoderWBDst2 \
# outRegisters

#        busRes1, busRes2: in std_logic_vector(n-1 downto 0);
#        WB1, WB2, ResetRegs, clk:in std_logic; 
#        src1, dst1, src2, dst2,WBdst1,WBdst2:in std_logic_vector(integer(log2(real(numRegs))) - 1 downto 0));

vsim work.genenralpurposeregfile

add wave -position insertpoint  \
sim:/genenralpurposeregfile/* 
force -freeze sim:/genenralpurposeregfile/clk 1 0, 0 {50 ps} -r 100
force -freeze sim:/genenralpurposeregfile/ResetRegs 1'h1 0
run
force -freeze sim:/genenralpurposeregfile/ResetRegs 1'h0 0

force -freeze sim:/genenralpurposeregfile/dst1 3'h0 0
force -freeze sim:/genenralpurposeregfile/dst2 3'h4 0
force -freeze sim:/genenralpurposeregfile/src1 3'h2 0
force -freeze sim:/genenralpurposeregfile/src2 3'h3 0

force -freeze sim:/genenralpurposeregfile/WBdst1 3'h0 0
force -freeze sim:/genenralpurposeregfile/WBdst2 3'h4 0
force -freeze sim:/genenralpurposeregfile/WB1 1'h1 0
force -freeze sim:/genenralpurposeregfile/WB2 1'h1 0

force -freeze sim:/genenralpurposeregfile/busRes1 16'h14 0
force -freeze sim:/genenralpurposeregfile/busRes2 16'h15 0
run
force -freeze sim:/genenralpurposeregfile/WBdst1 3'h2 0
force -freeze sim:/genenralpurposeregfile/WBdst2 3'h3 0

force -freeze sim:/genenralpurposeregfile/busRes1 16'h17 0
force -freeze sim:/genenralpurposeregfile/busRes2 16'h16 0
run

force -freeze sim:/genenralpurposeregfile/WB1 1'h0 0
force -freeze sim:/genenralpurposeregfile/WB2 1'h0 0

force -freeze sim:/genenralpurposeregfile/WBdst1 3'h2 0
force -freeze sim:/genenralpurposeregfile/WBdst2 3'h3 0

force -freeze sim:/genenralpurposeregfile/busRes1 16'h19 0
force -freeze sim:/genenralpurposeregfile/busRes2 16'h20 0
run
