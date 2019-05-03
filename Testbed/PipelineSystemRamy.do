# restart -f -nowave
vsim work.pipelinesystem

add wave  -group MainSystem sim:/pipelinesystem/clk sim:/pipelinesystem/INPort sim:/pipelinesystem/rst sim:/pipelinesystem/OutPort sim:/pipelinesystem/EXMEMbufferD sim:/pipelinesystem/EXMEMbufferQ sim:/pipelinesystem/IDEXBufferD sim:/pipelinesystem/IDEXBufferQ sim:/pipelinesystem/IFIDBufferD sim:/pipelinesystem/IFIDBufferQ sim:/pipelinesystem/MEMWBbufferD sim:/pipelinesystem/MEMWBbufferQ sim:/pipelinesystem/PCReg sim:/pipelinesystem/interruptSignal sim:/pipelinesystem/resetSignal sim:/pipelinesystem/DecodeStageEnt/preIDEXBuffer 

add wave  -group RegFile -label "R0" sim:/pipelinesystem/DecodeStageEnt/regFileEnt/loopGenerateRegs(0)/Reg/Q  -label "R1" sim:/pipelinesystem/DecodeStageEnt/regFileEnt/loopGenerateRegs(1)/Reg/Q -label "R2" sim:/pipelinesystem/DecodeStageEnt/regFileEnt/loopGenerateRegs(2)/Reg/Q  -label "R3" sim:/pipelinesystem/DecodeStageEnt/regFileEnt/loopGenerateRegs(3)/Reg/Q -label "R4" sim:/pipelinesystem/DecodeStageEnt/regFileEnt/loopGenerateRegs(4)/Reg/Q -label "R5" sim:/pipelinesystem/DecodeStageEnt/regFileEnt/loopGenerateRegs(5)/Reg/Q -label "R6" sim:/pipelinesystem/DecodeStageEnt/regFileEnt/loopGenerateRegs(6)/Reg/Q -label "R7" sim:/pipelinesystem/DecodeStageEnt/regFileEnt/loopGenerateRegs(7)/Reg/Q


# add wave  -group MainSystemAll  sim:/pipelinesystem/*

# DecodeStageEnt
# add wave -position insertpoint sim:/pipelinesystem/DecodeStageEnt/*
# add wave -position insertpoint sim:/pipelinesystem/DecodeStageEnt/controlUnitEnt/*
# add wave -position insertpoint sim:/pipelinesystem/DecodeStageEnt/regFileEnt/*

add wave  -group ALU1  sim:/pipelinesystem/ExecuteStageEnt/ALU1Ent/*
add wave  -group ALU2  sim:/pipelinesystem/ExecuteStageEnt/ALU2Ent/*
add wave  -group ForwardUnit  sim:/pipelinesystem/ExecuteStageEnt/ForwardUnitEnt/*


config wave -signalnamewidth 1

restart -f

mem load -i C:/Users/ramym/Desktop/SecondTerm/Arch/Pipeline-Processor/Assembler/testcases/OneOperand/mem11.mem /pipelinesystem/FetchStageEnt/CodeRamEnt/Ram
mem load -i C:/Users/ramym/Desktop/SecondTerm/Arch/Pipeline-Processor/Assembler/testcases/OneOperand/mem11.mem /pipelinesystem/MemoryStageEnt/MEMENTITY/Ram

force -freeze sim:/pipelinesystem/clk 1 0, 0 {50 ns} -r 100
force -freeze sim:/pipelinesystem/rst 1 0
force -freeze sim:/pipelinesystem/interruptSignal 0 0
force -freeze sim:/pipelinesystem/resetSignal 0 0
run
force -freeze sim:/pipelinesystem/rst 0 0
run
force -freeze sim:/pipelinesystem/resetSignal 1 0
run
force -freeze sim:/pipelinesystem/resetSignal 0 0
run
force -freeze sim:/pipelinesystem/INPort 16'h19 0
run
force -freeze sim:/pipelinesystem/INPort 16'hFFFF 0
run
force -freeze sim:/pipelinesystem/INPort 16'hF320 0
run
