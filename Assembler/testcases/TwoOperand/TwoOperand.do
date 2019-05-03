# restart -f -nowave
vsim work.pipelinesystem

add wave  -group MainSystem sim:/pipelinesystem/clk sim:/pipelinesystem/INPort sim:/pipelinesystem/rst sim:/pipelinesystem/OutPort  sim:/pipelinesystem/PCReg sim:/pipelinesystem/interruptSignal sim:/pipelinesystem/resetSignal  

add wave  -group RegFile -label "R0" sim:/pipelinesystem/DecodeStageEnt/regFileEnt/loopGenerateRegs(0)/Reg/Q  -label "R1" sim:/pipelinesystem/DecodeStageEnt/regFileEnt/loopGenerateRegs(1)/Reg/Q -label "R2" sim:/pipelinesystem/DecodeStageEnt/regFileEnt/loopGenerateRegs(2)/Reg/Q  -label "R3" sim:/pipelinesystem/DecodeStageEnt/regFileEnt/loopGenerateRegs(3)/Reg/Q -label "R4" sim:/pipelinesystem/DecodeStageEnt/regFileEnt/loopGenerateRegs(4)/Reg/Q -label "R5" sim:/pipelinesystem/DecodeStageEnt/regFileEnt/loopGenerateRegs(5)/Reg/Q -label "R6" sim:/pipelinesystem/DecodeStageEnt/regFileEnt/loopGenerateRegs(6)/Reg/Q -label "R7" sim:/pipelinesystem/DecodeStageEnt/regFileEnt/loopGenerateRegs(7)/Reg/Q

add wave  -group FlagsUnit  sim:/pipelinesystem/ExecuteStageEnt/FlagsUnitEnt/FlagsRegIn sim:/pipelinesystem/ExecuteStageEnt/FlagsUnitEnt/FlagsFromALU1 sim:/pipelinesystem/ExecuteStageEnt/FlagsUnitEnt/FlagsFromALU2

config wave -signalnamewidth 1

restart -f
mem load -i C:/Users/PC-PC/Desktop/Pipeline-Processor/Assembler/testcases/TwoOperand/mem11.mem /pipelinesystem/FetchStageEnt/CodeRamEnt/Ram
mem load -i C:/Users/PC-PC/Desktop/Pipeline-Processor/Assembler/testcases/TwoOperand/mem11.mem /pipelinesystem/MemoryStageEnt/MEMENTITY/Ram


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
force -freeze sim:/pipelinesystem/INPort 16'h5 0
run
force -freeze sim:/pipelinesystem/INPort 16'h19 0
run
force -freeze sim:/pipelinesystem/INPort 16'hFFFF 0
run
force -freeze sim:/pipelinesystem/INPort 16'hF320 0
run 800
