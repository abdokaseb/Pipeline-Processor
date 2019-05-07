vsim work.pipelinesystem
set StdArithNoWarnings 1
set NumericStdNoWarnings 1

add wave  -group MainSystem sim:/pipelinesystem/clk sim:/pipelinesystem/INPort sim:/pipelinesystem/rst sim:/pipelinesystem/OutPort  sim:/pipelinesystem/PCReg sim:/pipelinesystem/interruptSignal sim:/pipelinesystem/resetSignal  

add wave  -group RegFile -label "R0" sim:/pipelinesystem/DecodeStageEnt/regFileEnt/loopGenerateRegs(0)/Reg/Q  -label "R1" sim:/pipelinesystem/DecodeStageEnt/regFileEnt/loopGenerateRegs(1)/Reg/Q -label "R2" sim:/pipelinesystem/DecodeStageEnt/regFileEnt/loopGenerateRegs(2)/Reg/Q  -label "R3" sim:/pipelinesystem/DecodeStageEnt/regFileEnt/loopGenerateRegs(3)/Reg/Q -label "R4" sim:/pipelinesystem/DecodeStageEnt/regFileEnt/loopGenerateRegs(4)/Reg/Q -label "R5" sim:/pipelinesystem/DecodeStageEnt/regFileEnt/loopGenerateRegs(5)/Reg/Q -label "R6" sim:/pipelinesystem/DecodeStageEnt/regFileEnt/loopGenerateRegs(6)/Reg/Q -label "R7" sim:/pipelinesystem/DecodeStageEnt/regFileEnt/loopGenerateRegs(7)/Reg/Q

add wave  -group FlagsUnit sim:/pipelinesystem/ExecuteStageEnt/FlagsUnitEnt/FlagsRegIn sim:/pipelinesystem/ExecuteStageEnt/FlagsUnitEnt/FlagsFromALU1 sim:/pipelinesystem/ExecuteStageEnt/FlagsUnitEnt/FlagsFromALU2

add wave -group Memory -label "newSp" sim:/pipelinesystem/MemoryStageEnt/CALCMEMPARAMSENT/SPRegIn -label "currSP" sim:/pipelinesystem/MemoryStageEnt/CALCMEMPARAMSENT/SPRegOut -label "MemRead" sim:/pipelinesystem/MemoryStageEnt/CALCMEMPARAMSENT/MemRead -label "MemWrite" sim:/pipelinesystem/MemoryStageEnt/CALCMEMPARAMSENT/MemWrite -label "addressToMem" sim:/pipelinesystem/MemoryStageEnt/CALCMEMPARAMSENT/addressToMem  -label "data1ToMem" sim:/pipelinesystem/MemoryStageEnt/CALCMEMPARAMSENT/dataToMem1  -label "data2ToMem" sim:/pipelinesystem/MemoryStageEnt/CALCMEMPARAMSENT/dataToMem2 -label "data1FromMem" sim:/pipelinesystem/MemoryStageEnt/MEMSTAGEOUTPUTENT/dataFromMem1 -label "data2FromMem" sim:/pipelinesystem/MemoryStageEnt/MEMSTAGEOUTPUTENT/dataFromMem2 

add wave -group buffers sim:/pipelinesystem/IFIDBufferD sim:/pipelinesystem/IFIDBufferQ sim:/pipelinesystem/IDEXBufferD sim:/pipelinesystem/IDEXBufferQ sim:/pipelinesystem/EXMEMbufferD sim:/pipelinesystem/EXMEMbufferQ sim:/pipelinesystem/MEMWBbufferD sim:/pipelinesystem/MEMWBbufferQ

restart -f
mem load -i C:/Users/PC-PC/Desktop/Pipeline-Processor/Assembler/testcases/Memory/mem11.mem /pipelinesystem/FetchStageEnt/CodeRamEnt/Ram
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
force -freeze sim:/pipelinesystem/resetSignal 1 0
run
force -freeze sim:/pipelinesystem/resetSignal 0 0
run
force -freeze sim:/pipelinesystem/INPort 16'h19 0
run
force -freeze sim:/pipelinesystem/INPort 16'hFFFF 0
run
force -freeze sim:/pipelinesystem/INPort 16'hF320 0
run 1500