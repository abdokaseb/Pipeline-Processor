vsim work.pccontrolunit
add wave -position insertpoint sim:/pccontrolunit/*
# restart -f
force -freeze sim:/pccontrolunit/clk 1 0, 0 {50 ps} -r 100
force -freeze sim:/pccontrolunit/reset 1 0
run 
force -freeze sim:/pccontrolunit/reset 0 0
force -freeze sim:/pccontrolunit/ExPcEnable 0 0
force -freeze sim:/pccontrolunit/MemPcEnable 0 0
force -freeze sim:/pccontrolunit/ControlPCoperation 2'b10 0
force -freeze sim:/pccontrolunit/MemPc 0 0
force -freeze sim:/pccontrolunit/ExPc 0 0
force -freeze sim:/pccontrolunit/InterruptS 0 0
force -freeze sim:/pccontrolunit/InterruptE 0 0
run 
run 
run 
force -freeze sim:/pccontrolunit/MemPc 30 0
run 
force -freeze sim:/pccontrolunit/MemPcEnable 1 0
run 
force -freeze sim:/pccontrolunit/MemPcEnable 0 0
run 
run 
force -freeze sim:/pccontrolunit/MemPc 30 0
force -freeze sim:/pccontrolunit/MemPcEnable 1 0
run 
force -freeze sim:/pccontrolunit/MemPcEnable 0 0
run 
force -freeze sim:/pccontrolunit/InterruptS 1 0
run 
force -freeze sim:/pccontrolunit/InterruptS 0 0
run 
run 
run 
force -freeze sim:/pccontrolunit/InterruptE 1 0
run 
force -freeze sim:/pccontrolunit/InterruptE 0 0
run 
run 

force -freeze sim:/pccontrolunit/InterruptS 1 0
run 
force -freeze sim:/pccontrolunit/InterruptS 0 0
run 
run 
force -freeze sim:/pccontrolunit/MemPc 30 0
force -freeze sim:/pccontrolunit/MemPcEnable 1 0
run 
force -freeze sim:/pccontrolunit/MemPcEnable 0 0
run 
force -freeze sim:/pccontrolunit/InterruptE 1 0
run 
force -freeze sim:/pccontrolunit/InterruptE 0 0
run 
run 



