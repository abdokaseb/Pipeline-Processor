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
sim:/pipelinesystem/interruptSignal \
sim:/pipelinesystem/MemoryStageEnt/CALCMEMPARAMSENT/SPRegOut \
 sim:/pipelinesystem/MemoryStageEnt/CALCMEMPARAMSENT/SPRegIn

add wave -position insertpoint sim:/pipelinesystem/ExecuteStageEnt/*
#*/
#add wave -position insertpoint sim:/pipelinesystem/MemoryStageEnt/*
#*/

add wave -position insertpoint sim:/pipelinesystem/DecodeStageEnt/regFileEnt/loopGenerateRegs(0)/Reg/Q
add wave -position insertpoint sim:/pipelinesystem/DecodeStageEnt/regFileEnt/loopGenerateRegs(1)/Reg/Q
add wave -position insertpoint sim:/pipelinesystem/DecodeStageEnt/regFileEnt/loopGenerateRegs(2)/Reg/Q
add wave -position insertpoint sim:/pipelinesystem/DecodeStageEnt/regFileEnt/loopGenerateRegs(3)/Reg/Q
add wave -position insertpoint sim:/pipelinesystem/DecodeStageEnt/regFileEnt/loopGenerateRegs(4)/Reg/Q
add wave -position insertpoint sim:/pipelinesystem/DecodeStageEnt/regFileEnt/loopGenerateRegs(5)/Reg/Q
add wave -position insertpoint sim:/pipelinesystem/DecodeStageEnt/regFileEnt/loopGenerateRegs(6)/Reg/Q
add wave -position insertpoint sim:/pipelinesystem/DecodeStageEnt/regFileEnt/loopGenerateRegs(7)/Reg/Q

add wave -position end  sim:/pipelinesystem/ExecuteStageEnt/ControHazardsUnit/condition1
add wave -position end  sim:/pipelinesystem/ExecuteStageEnt/ControHazardsUnit/condition2
add wave -position 39  sim:/pipelinesystem/ExecuteStageEnt/ControHazardsUnit/BranchExeFlags1
add wave -position 40  sim:/pipelinesystem/ExecuteStageEnt/ControHazardsUnit/BranchExeFlags2
add wave -position 31  sim:/pipelinesystem/MemoryStageEnt/CALCMEMPARAMSENT/RTIstate
add wave -position 32  sim:/pipelinesystem/MemoryStageEnt/CALCMEMPARAMSENT/INTstate

restart -f
mem load -i C:/Users/PC-PC/Desktop/Pipeline-Processor/Assembler/testcases/Branch/mem11.mem /pipelinesystem/FetchStageEnt/CodeRamEnt/Ram
mem load -filltype value -filldata 0000 -fillradix hexadecimal /pipelinesystem/MemoryStageEnt/MEMENTITY/Ram(0)
mem load -filltype value -filldata 0010 -fillradix hexadecimal /pipelinesystem/MemoryStageEnt/MEMENTITY/Ram(1)
mem load -filltype value -filldata 0000 -fillradix hexadecimal /pipelinesystem/MemoryStageEnt/MEMENTITY/Ram(2)
mem load -filltype value -filldata 0100 -fillradix hexadecimal /pipelinesystem/MemoryStageEnt/MEMENTITY/Ram(3)


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
force -freeze sim:/pipelinesystem/INPort 16'h30 0
run
force -freeze sim:/pipelinesystem/INPort 16'h50 0
run
force -freeze sim:/pipelinesystem/INPort 16'h100 0
run
force -freeze sim:/pipelinesystem/INPort 16'h300 0
run 300
force -freeze sim:/pipelinesystem/interruptSignal 1 0
run
force -freeze sim:/pipelinesystem/interruptSignal 0 0
run 1400
force -freeze sim:/pipelinesystem/INPort 16'h200 0
run 600
force -freeze sim:/pipelinesystem/interruptSignal 1 0
run
force -freeze sim:/pipelinesystem/interruptSignal 0 0
