vsim work.alu

# restart -f
add wave -position insertpoint sim:/alu/*

# A, B: in std_logic_vector(n-1 downto 0);
# F: out std_logic_vector(n-1 downto 0);
# shiftAm: in std_logic_vector(nshift-1 downto 0);
# operationControl: in std_logic_vector(m-1 downto 0);
# flagIn: in std_logic_vector(flagsCount-1 downto 0);
# flagOut: out std_logic_vector(flagsCount-1 downto 0));

force -freeze sim:/alu/B 16'h9014 0
force -freeze sim:/alu/A 16'h2 0
force -freeze sim:/alu/flagIn 4'h2 0
force -freeze sim:/alu/shiftAm 4'h2 0
force -freeze sim:/alu/operationControl 4'b2 0
run


force -freeze sim:/alu/operationControl 4'b0000
run
force -freeze sim:/alu/operationControl 4'b0001
run
force -freeze sim:/alu/operationControl 4'b0010
run
force -freeze sim:/alu/operationControl 4'b0011
run
force -freeze sim:/alu/operationControl 4'b0100
run
force -freeze sim:/alu/operationControl 4'b0101
run
force -freeze sim:/alu/operationControl 4'b0110
run
force -freeze sim:/alu/operationControl 4'b0111
run
force -freeze sim:/alu/operationControl 4'b1001
run
force -freeze sim:/alu/operationControl 4'b1010
run
force -freeze sim:/alu/operationControl 4'b1011
run
force -freeze sim:/alu/operationControl 4'b1100
run
force -freeze sim:/alu/operationControl 4'b1101
run