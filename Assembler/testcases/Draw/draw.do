
# restart -f -nowave
# vsim work.pipelinesystem

add wave  -group MainSystem sim:/pipelinesystem/clk sim:/pipelinesystem/INPort sim:/pipelinesystem/rst sim:/pipelinesystem/OutPort sim:/pipelinesystem/PCReg sim:/pipelinesystem/interruptSignal sim:/pipelinesystem/resetSignal sim:/pipelinesystem/DecodeStageEnt/preIDEXBuffer 
add wave -group IFIDfD sim:/pipelinesystem/IFIDRegEnt/BUFGENIFID/firstD sim:/pipelinesystem/IFIDRegEnt/BUFGENIFID/SecondD sim:/pipelinesystem/IFIDRegEnt/BUFGENIFID/firstq sim:/pipelinesystem/IFIDRegEnt/BUFGENIFID/Secondq sim:/pipelinesystem/IFIDRegEnt/BUFGENIFID/commond sim:/pipelinesystem/IFIDRegEnt/BUFGENIFID/commonq

add wave -group IDEXfD sim:/pipelinesystem/IDEXRegEnt/BUFGENIDEX/firstD sim:/pipelinesystem/IDEXRegEnt/BUFGENIDEX/SecondD sim:/pipelinesystem/IDEXRegEnt/BUFGENIDEX/firstq sim:/pipelinesystem/IDEXRegEnt/BUFGENIDEX/Secondq sim:/pipelinesystem/IDEXRegEnt/BUFGENIDEX/commond sim:/pipelinesystem/IDEXRegEnt/BUFGENIDEX/commonq

add wave -group EXMEMfD sim:/pipelinesystem/EXMEMRegEnt/BUFGENEXMEM/firstD sim:/pipelinesystem/EXMEMRegEnt/BUFGENEXMEM/SecondD sim:/pipelinesystem/EXMEMRegEnt/BUFGENEXMEM/firstq sim:/pipelinesystem/EXMEMRegEnt/BUFGENEXMEM/Secondq

add wave  -group RegFile sim:/pipelinesystem/DecodeStageEnt/regFileEnt/loopGenerateRegs(0)/Reg/Q sim:/pipelinesystem/DecodeStageEnt/regFileEnt/loopGenerateRegs(1)/Reg/Q sim:/pipelinesystem/DecodeStageEnt/regFileEnt/loopGenerateRegs(2)/Reg/Q sim:/pipelinesystem/DecodeStageEnt/regFileEnt/loopGenerateRegs(3)/Reg/Q sim:/pipelinesystem/DecodeStageEnt/regFileEnt/loopGenerateRegs(4)/Reg/Q sim:/pipelinesystem/DecodeStageEnt/regFileEnt/loopGenerateRegs(5)/Reg/Q sim:/pipelinesystem/DecodeStageEnt/regFileEnt/loopGenerateRegs(6)/Reg/Q sim:/pipelinesystem/DecodeStageEnt/regFileEnt/loopGenerateRegs(7)/Reg/Q


add wave  -group MainSystemAll  sim:/pipelinesystem/*

# DecodeStageEnt
# add wave -position insertpoint sim:/pipelinesystem/DecodeStageEnt/*
# add wave -position insertpoint sim:/pipelinesystem/DecodeStageEnt/controlUnitEnt/*
# add wave -position insertpoint sim:/pipelinesystem/DecodeStageEnt/regFileEnt/*

add wave  -group ALU1  sim:/pipelinesystem/ExecuteStageEnt/ALU1Ent/*
add wave  -group ALU2  sim:/pipelinesystem/ExecuteStageEnt/ALU2Ent/*
add wave  -group ForwardUnit  sim:/pipelinesystem/ExecuteStageEnt/ForwardUnitEnt/*
add wave -group PCUnit sim:/pipelinesystem/PCControlUnitEnt/*
add wave -group AddedToPC sim:/pipelinesystem/DecodeStageEnt/controlUnitEnt/AddToPCEnt/*
add wave -group Decode sim:/pipelinesystem/DecodeStageEnt/*


add wave -group controlHazard sim:/pipelinesystem/ExecuteStageEnt/ControHazardsUnit/*


# 
# restart -f

mem load -i Assembler/testcases/Draw/draw.mem /pipelinesystem/FetchStageEnt/CodeRamEnt/Ram
mem load -i Assembler/testcases/Draw/draw.mem /pipelinesystem/MemoryStageEnt/MEMENTITY/Ram

force -freeze sim:/pipelinesystem/clk 1 0, 0 {50 ps} -r 100
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
run 153000
mem save -o Assembler/testcases/Draw/exported.mem -f mti -data hex -addr hex -startaddress 342 -endaddress 1272 -wordsperline 19 /pipelinesystem/MemoryStageEnt/MEMENTITY/Ram



# force -freeze sim:/pipelinesystem/interruptSignal 1 0
# run
# force -freeze sim:/pipelinesystem/interruptSignal 0 0
# run 1000