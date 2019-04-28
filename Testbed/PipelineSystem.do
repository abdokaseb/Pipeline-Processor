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
add wave -position insertpoint sim:/pipelinesystem/DecodeStageEnt/*
add wave -position insertpoint sim:/pipelinesystem/DecodeStageEnt/controlUnitEnt/*



# restart -f
mem load -i Assembler/out.mem /pipelinesystem/FetchStageEnt/CodeRamEnt/Ram

force -freeze sim:/pipelinesystem/clk 1 0, 0 {50 ps} -r 100
# force -freeze sim:/pipelinesystem/clk 0 0, 1 {50 ps} -r 100
force -freeze sim:/pipelinesystem/rst 1 0
force -freeze sim:/pipelinesystem/interruptSignal 0 0
force -freeze sim:/pipelinesystem/resetSignal 0 0

# force -freeze sim:/pipelinesystem/IFIDrst 1 0
# force -freeze sim:/pipelinesystem/IDEXrst 1 0
# force -freeze sim:/pipelinesystem/EXMEMrst 1 0
# force -freeze sim:/pipelinesystem/MEMWBrst 1 0
run
force -freeze sim:/pipelinesystem/IDEXBufferD 166'h0 0
force -freeze sim:/pipelinesystem/rst 0 0
force -freeze sim:/pipelinesystem/INPort 16'h5 0
force -freeze sim:/pipelinesystem/IFIDrst 0 0
run
noforce sim:/pipelinesystem/IDEXBufferD
force -freeze sim:/pipelinesystem/INPort 16'h19 0
force -freeze sim:/pipelinesystem/IDEXrst 0 0
run
force -freeze sim:/pipelinesystem/INPort 16'hFFFF 0
force -freeze sim:/pipelinesystem/EXMEMrst 0 0
run
force -freeze sim:/pipelinesystem/INPort 16'hF320 0
force -freeze sim:/pipelinesystem/MEMWBrst 0 0
run
run
run 2000
