add wave -position end \
sim:/buffwithflushgen/rst \
sim:/buffwithflushgen/en \
sim:/buffwithflushgen/firstFlush \
sim:/buffwithflushgen/secondFlush \
sim:/buffwithflushgen/commonFlush \
sim:/buffwithflushgen/buffD \
sim:/buffwithflushgen/buffQ \
sim:/buffwithflushgen/clk \
sim:/buffwithflushgen/len 

restart -f
force -freeze sim:/buffwithflushgen/en 1 0
force -freeze sim:/buffwithflushgen/secondFlush 0 0
force -freeze sim:/buffwithflushgen/firstFlush 0 0
force -freeze sim:/buffwithflushgen/commonFlush 0 0
force -freeze sim:/buffwithflushgen/rst 1 0
force -freeze sim:/buffwithflushgen/clk 1 0, 0 {50 ns} -r 100
run 
run
force -freeze sim:/buffwithflushgen/rst 0 0
force -freeze sim:/buffwithflushgen/en 0 0
run
force -freeze sim:/buffwithflushgen/en 1 0
run
run
force -freeze sim:/buffwithflushgen/buffD 64'hffffffffffffffff 0
run
force -freeze sim:/buffwithflushgen/firstFlush 1 0
run
force -freeze sim:/buffwithflushgen/firstFlush 0 0
run
force -freeze sim:/buffwithflushgen/secondFlush 1 0
run
force -freeze sim:/buffwithflushgen/secondFlush 0 0
run
force -freeze sim:/buffwithflushgen/commonFlush 1 0
run
force -freeze sim:/buffwithflushgen/commonFlush 0 0
run
force -freeze sim:/buffwithflushgen/firstFlush 1 0
force -freeze sim:/buffwithflushgen/secondFlush 1 0
force -freeze sim:/buffwithflushgen/commonFlush 1 0
run
run