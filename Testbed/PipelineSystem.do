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

add wave -position insertpoint sim:/pipelinesystem/DecodeStageEnt/regFileEnt/loopGenerateRegs(0)/Reg/Q
add wave -position insertpoint sim:/pipelinesystem/DecodeStageEnt/regFileEnt/loopGenerateRegs(1)/Reg/Q
add wave -position insertpoint sim:/pipelinesystem/DecodeStageEnt/regFileEnt/loopGenerateRegs(2)/Reg/Q
add wave -position insertpoint sim:/pipelinesystem/DecodeStageEnt/regFileEnt/loopGenerateRegs(3)/Reg/Q
add wave -position insertpoint sim:/pipelinesystem/DecodeStageEnt/regFileEnt/loopGenerateRegs(4)/Reg/Q
add wave -position insertpoint sim:/pipelinesystem/DecodeStageEnt/regFileEnt/loopGenerateRegs(5)/Reg/Q
add wave -position insertpoint sim:/pipelinesystem/DecodeStageEnt/regFileEnt/loopGenerateRegs(6)/Reg/Q
add wave -position insertpoint sim:/pipelinesystem/DecodeStageEnt/regFileEnt/loopGenerateRegs(7)/Reg/Q

# restart -f
mem load -i /home/ayman/Desktop/Project/Arch/Assembler/testcases/TwoOperand/mem11.mem /pipelinesystem/FetchStageEnt/CodeRamEnt/Ram

force -freeze sim:/pipelinesystem/clk 1 0, 0 {50 ps} -r 100
force -freeze sim:/pipelinesystem/rst 1 0
run
force -freeze sim:/pipelinesystem/rst 0 0
run
run
