# restart -f -nowave
vsim work.pipelinesystem
add wave -position insertpoint  \
sim:/pipelinesystem/clk \
sim:/pipelinesystem/INPort \
sim:/pipelinesystem/rst \
sim:/pipelinesystem/OutPort \
sim:/pipelinesystem/EXMEMbufferD \
sim:/pipelinesystem/EXMEMbufferQ \
sim:/pipelinesystem/IDEXBufferD \
sim:/pipelinesystem/IDEXBufferQ \
sim:/pipelinesystem/IFIDBufferD \
sim:/pipelinesystem/IFIDBufferQ \
sim:/pipelinesystem/MEMWBbufferD \
sim:/pipelinesystem/MEMWBbufferQ \
sim:/pipelinesystem/PCReg \
sim:/pipelinesystem/interruptSignal \
sim:/pipelinesystem/resetSignal \
sim:/pipelinesystem/DecodeStageEnt/preIDEXBuffer \

add wave -position insertpoint sim:/pipelinesystem/DecodeStageEnt/regFileEnt/loopGenerateRegs(0)/Reg/Q
add wave -position insertpoint sim:/pipelinesystem/DecodeStageEnt/regFileEnt/loopGenerateRegs(1)/Reg/Q
add wave -position insertpoint sim:/pipelinesystem/DecodeStageEnt/regFileEnt/loopGenerateRegs(2)/Reg/Q
add wave -position insertpoint sim:/pipelinesystem/DecodeStageEnt/regFileEnt/loopGenerateRegs(3)/Reg/Q
add wave -position insertpoint sim:/pipelinesystem/DecodeStageEnt/regFileEnt/loopGenerateRegs(4)/Reg/Q
add wave -position insertpoint sim:/pipelinesystem/DecodeStageEnt/regFileEnt/loopGenerateRegs(5)/Reg/Q
add wave -position insertpoint sim:/pipelinesystem/DecodeStageEnt/regFileEnt/loopGenerateRegs(6)/Reg/Q
add wave -position insertpoint sim:/pipelinesystem/DecodeStageEnt/regFileEnt/loopGenerateRegs(7)/Reg/Q


add wave -position insertpoint sim:/pipelinesystem/*
# DecodeStageEnt
add wave -position insertpoint sim:/pipelinesystem/DecodeStageEnt/*
add wave -position insertpoint sim:/pipelinesystem/DecodeStageEnt/controlUnitEnt/*
add wave -position insertpoint sim:/pipelinesystem/DecodeStageEnt/regFileEnt/*
# ExecuteStageEnt
add wave -position insertpoint sim:/pipelinesystem/ExecuteStageEnt/ALU1Ent/*
add wave -position insertpoint sim:/pipelinesystem/ExecuteStageEnt/ALU2Ent/*
add wave -position insertpoint sim:/pipelinesystem/ExecuteStageEnt/ForwardUnitEnt/*




restart -f

mem load -i C:/Users/PC-PC/Desktop/Pipeline-Processor/Testbed/partsTest/testOut/mem.mem /pipelinesystem/FetchStageEnt/CodeRamEnt/Ram
mem load -filltype value -filldata 0000 -fillradix hexadecimal /pipelinesystem/MemoryStageEnt/MEMENTITY/Ram(0)
mem load -filltype value -filldata 0010 -fillradix hexadecimal /pipelinesystem/MemoryStageEnt/MEMENTITY/Ram(1)

force -freeze sim:/pipelinesystem/clk 1 0, 0 {50 ps} -r 100
force -freeze sim:/pipelinesystem/rst 1 0
force -freeze sim:/pipelinesystem/interruptSignal 0 0
force -freeze sim:/pipelinesystem/resetSignal 0 0
run
force -freeze sim:/pipelinesystem/rst 0 0
run
force -freeze sim:/pipelinesystem/resetSignal 1 0
run
force -freeze sim:/pipelinesystem/resetSignal 0 0
force -freeze sim:/pipelinesystem/INPort 16'h19 0
run
force -freeze sim:/pipelinesystem/INPort 16'hFFFF 0
run
force -freeze sim:/pipelinesystem/INPort 16'hF320 0
run
