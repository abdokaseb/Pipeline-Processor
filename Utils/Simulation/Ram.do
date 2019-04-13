vsim work.ram
add wave -position insertpoint sim:/ram/*

### clk : IN STD_LOGIC;
### we,twoWords  : IN STD_LOGIC;
### address : IN  STD_LOGIC_VECTOR(addressBits - 1 DOWNTO 0);
### datain1,datain2  : IN  STD_LOGIC_VECTOR(wordSize - 1 DOWNTO 0);
### dataout1,dataout2 : OUT STD_LOGIC_VECTOR(wordSize - 1 DOWNTO 0)

force -freeze sim:/ram/clk 1 0, 0 {50 ps} -r 100
force -freeze sim:/ram/address 5'h2 0
force -freeze sim:/ram/we 1'h1 0
force -freeze sim:/ram/datain1 16'h16 0
run

force -freeze sim:/ram/address 5'h3 0
force -freeze sim:/ram/we 1'h1 0
force -freeze sim:/ram/twoWords 1'h1 0
force -freeze sim:/ram/datain1 16'h15 0
force -freeze sim:/ram/datain2 16'h14 0
run

force -freeze sim:/ram/address 5'h1 0
force -freeze sim:/ram/we 1'h0 0
run
force -freeze sim:/ram/address 5'h2 0
run
force -freeze sim:/ram/address 5'h3 0
run
