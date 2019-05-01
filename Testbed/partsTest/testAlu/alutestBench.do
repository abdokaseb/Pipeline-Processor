vsim -gui work.alutestbench
# vsim 
# Start time: 12:10:54 on May 01,2019
# Loading std.standard
# Loading std.textio(body)
# Loading ieee.std_logic_1164(body)
# Loading work.constants
# Loading ieee.numeric_std(body)
# Loading work.alutestbench(alutestbencharch)
# Loading work.alu(aluarch)
# Loading work.nbitadder(nbitadderarch)
# Loading work.fulladder(fulladderarch)
add wave -position insertpoint  \
sim:/alutestbench/clk \
sim:/alutestbench/A \
sim:/alutestbench/B \
sim:/alutestbench/F \
sim:/alutestbench/ShiftAmount \
sim:/alutestbench/Operation \
sim:/alutestbench/flagIn \
sim:/alutestbench/flagOut


# --- setc  clc --
run
run

# ---- NOT 
run
run

# ---- inc 
run
run
run

# ---- dec
run
run
run
# ----- mov
run
# ----- add
run
run
run
run
run
run
# -----  sub
run
run
run
run
run

# ---and
run
run

# --- or 
run
run
run

# --- shl
run
run

# --- shr
run