restart -f -nowave
set StdArithNoWarnings 1
set NumericStdNoWarnings 1

add wave -position insertpoint \
sim:/pipelinesystem/clk \
sim:/pipelinesystem/rst \
sim:/pipelinesystem/OutPort \
sim:/pipelinesystem/IFIDBufferD \
sim:/pipelinesystem/IFIDBufferQ \
sim:/pipelinesystem/IDEXBufferD \
sim:/pipelinesystem/IDEXBufferQ \
sim:/pipelinesystem/EXMEMbufferD \
sim:/pipelinesystem/EXMEMbufferQ \
sim:/pipelinesystem/MEMWBbufferD \
sim:/pipelinesystem/MEMWBbufferQ \
sim:/pipelinesystem/PCReg \
sim:/pipelinesystem/interruptSignal
add wave -position insertpoint sim:/pipelinesystem/MemoryStageEnt/*
#*/

add wave -position insertpoint sim:/pipelinesystem/DecodeStageEnt/regFileEnt/loopGenerateRegs(0)/Reg/Q
add wave -position insertpoint sim:/pipelinesystem/DecodeStageEnt/regFileEnt/loopGenerateRegs(1)/Reg/Q
add wave -position insertpoint sim:/pipelinesystem/DecodeStageEnt/regFileEnt/loopGenerateRegs(2)/Reg/Q
add wave -position insertpoint sim:/pipelinesystem/DecodeStageEnt/regFileEnt/loopGenerateRegs(3)/Reg/Q
add wave -position insertpoint sim:/pipelinesystem/DecodeStageEnt/regFileEnt/loopGenerateRegs(4)/Reg/Q
add wave -position insertpoint sim:/pipelinesystem/DecodeStageEnt/regFileEnt/loopGenerateRegs(5)/Reg/Q
add wave -position insertpoint sim:/pipelinesystem/DecodeStageEnt/regFileEnt/loopGenerateRegs(6)/Reg/Q
add wave -position insertpoint sim:/pipelinesystem/DecodeStageEnt/regFileEnt/loopGenerateRegs(7)/Reg/Q


restart -f
mem load -i C:/Users/PC-PC/Desktop/Pipeline-Processor/Assembler/testMem/mem.mem /pipelinesystem/FetchStageEnt/CodeRamEnt/Ram
force -freeze sim:/pipelinesystem/clk 1 0, 0 {50 ns} -r 100
force -freeze sim:/pipelinesystem/rst 1 0
force -freeze sim:/pipelinesystem/interruptSignal 0 0
force -freeze sim:/pipelinesystem/resetSignal 0 0
run
force -freeze sim:/pipelinesystem/IDEXBufferD 166'h0 0
force -freeze sim:/pipelinesystem/rst 0 0
run
noforce sim:/pipelinesystem/IDEXBufferD
force -freeze sim:/pipelinesystem/INPort 16'h19 0
run
force -freeze sim:/pipelinesystem/INPort 16'hFFFF 0
run
force -freeze sim:/pipelinesystem/INPort 16'hF320 0
run 1200