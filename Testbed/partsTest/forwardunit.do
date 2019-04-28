vsim -gui work.forwardunit


# first values and signals coming from decode stage 
add wave -position insertpoint  \
sim:/forwardunit/IdEXRsc1 \
sim:/forwardunit/IdEXRdst1 \
sim:/forwardunit/IdEXRsc2 \
sim:/forwardunit/IdEXRdst2

add wave -position insertpoint  \
sim:/forwardunit/RSrc1Value \
sim:/forwardunit/RDst1Value \
sim:/forwardunit/RSrc2Value \
sim:/forwardunit/RDst2Value

#  values from ex/mem

add wave -position insertpoint  \
sim:/forwardunit/ExMemRdst1 \
sim:/forwardunit/ExMemRdst2 \
sim:/forwardunit/ExMemWriteback1 \
sim:/forwardunit/ExMemWriteback2
add wave -position insertpoint  \
sim:/forwardunit/AluResult1 \
sim:/forwardunit/AluResult2


# values from mem/wb

add wave -position insertpoint  \
sim:/forwardunit/MemWbRdst1 \
sim:/forwardunit/MemWbRdst2 \
sim:/forwardunit/MemWbWriteback1 \
sim:/forwardunit/MemWbWriteback2 \
sim:/forwardunit/WbValue1 \
sim:/forwardunit/WbValue2

#  output


add wave -position insertpoint  \
sim:/forwardunit/Src1 \
sim:/forwardunit/Dst1 \
sim:/forwardunit/Src2 \
sim:/forwardunit/Dst2

#  please group each signal  parts before continue (make four groups ID|EX  EX|MEM  MEM|WB  output)

# i will test every output src1 Dst1 Src2 Dst2 in the same time so i will make them have the same rege number

force -freeze sim:/forwardunit/IdEXRsc1 3'h2 0
force -freeze sim:/forwardunit/IdEXRdst1 3'h2 0
force -freeze sim:/forwardunit/IdEXRsc2 3'h2 0
force -freeze sim:/forwardunit/IdEXRdst2 3'h2 0




# set value of forard values 

force -freeze sim:/forwardunit/AluResult2 16'h0004 0
force -freeze sim:/forwardunit/AluResult1 16'h0003 0
force -freeze sim:/forwardunit/WbValue2 16'h0002 0
force -freeze sim:/forwardunit/WbValue1 16'h0001 0

# ------------------- basic test cases ----------------------------------------------

# test case1 --- forward from  '1'  in  |3| |1|   (mem|wb 1)
# 					|4| |2|

force -freeze sim:/forwardunit/MemWbRdst1 3'h2 0
force -freeze sim:/forwardunit/MemWbWriteback1 1 0

run 

# output ---- src1 = dst1 =src2 =dst2 = 1  (value that has been forward is the value of wbvalue1 )

# test case2 --- forward from  '2' only  in  |3| |1|   (mem|wb 2)
# 					     |4| |2|

force -freeze sim:/forwardunit/MemWbWriteback1 0 0
force -freeze sim:/forwardunit/MemWbRdst2 3'h2 0
force -freeze sim:/forwardunit/MemWbWriteback2 1 0

run 

# output ---- src1 = dst1 =src2 =dst2 = 2  (value that has been forward is the value of wbvalue2 )

# test case3 --- forward from  '3' only  in  |3| |1|   (ex|mem 1)
# 					     |4| |2|

force -freeze sim:/forwardunit/MemWbWriteback2 0 0
force -freeze sim:/forwardunit/ExMemRdst1 3'h2 0
force -freeze sim:/forwardunit/ExMemWriteback1 1 0
run


# output ---- src1 = dst1 =src2 =dst2 = 3  (value that has been forward is the value of aluresult1 )

# test case4 --- forward from  '4' only  in  |3| |1|   (ex|mem 2)
# 					     |4| |2|

force -freeze sim:/forwardunit/ExMemWriteback1 0 0
force -freeze sim:/forwardunit/ExMemRdst2 3'h2 0
force -freeze sim:/forwardunit/ExMemWriteback2 1 0
run

# output ---- src1 = dst1 =src2 =dst2 = 4  (value that has been forward is the value of aluresult2 )

# test case5 --- no forwarding   

force -freeze sim:/forwardunit/RSrc1Value 16'h0010 0
force -freeze sim:/forwardunit/RDst1Value 16'h0011 0
force -freeze sim:/forwardunit/RSrc2Value 16'h0020 0
force -freeze sim:/forwardunit/RDst2Value 16'h0021 0
force -freeze sim:/forwardunit/ExMemWriteback2 0 0
run

# output ---- src1 = 16'h0010   dst1 = 16'h0011  src2 =16'h0020  dst2 = 16'h0021   

# ---------------- priority test cases ----------------------------------

# test case1 --- forward from  '1' and '2'  in  |3| |1|  
# 						|4| |2|

force -freeze sim:/forwardunit/MemWbRdst1 3'h2 0
force -freeze sim:/forwardunit/MemWbWriteback1 1 0
force -freeze sim:/forwardunit/MemWbRdst2 3'h2 0
force -freeze sim:/forwardunit/MemWbWriteback2 1 0

run 

# output ---- src1 = dst1 =src2 =dst2 = 2  (value that has been forward is the value of wbvalue2)

# test case2 --- forward from  '1' and '2' and '3'   in  |3| |1|   
# 						         |4| |2|

force -freeze sim:/forwardunit/MemWbRdst1 3'h2 0
force -freeze sim:/forwardunit/MemWbWriteback1 1 0
force -freeze sim:/forwardunit/MemWbRdst2 3'h2 0
force -freeze sim:/forwardunit/MemWbWriteback2 1 0
force -freeze sim:/forwardunit/ExMemRdst1 3'h2 0
force -freeze sim:/forwardunit/ExMemWriteback1 1 0

run 

# output ---- src1 = dst1 =src2 =dst2 = 3  (value that has been forward is the value of aluresult1 )

# test case3 --- forward from  '1' and '2' and '3' and '4'   in  |3| |1|  
# 						         	 |4| |2|

force -freeze sim:/forwardunit/MemWbRdst1 3'h2 0
force -freeze sim:/forwardunit/MemWbWriteback1 1 0
force -freeze sim:/forwardunit/MemWbRdst2 3'h2 0
force -freeze sim:/forwardunit/MemWbWriteback2 1 0
force -freeze sim:/forwardunit/ExMemRdst1 3'h2 0
force -freeze sim:/forwardunit/ExMemWriteback1 1 0
force -freeze sim:/forwardunit/ExMemRdst2 3'h2 0
force -freeze sim:/forwardunit/ExMemWriteback2 1 0

run 

# output ---- src1 = dst1 =src2 =dst2 = 4  (value that has been forward is the value of wbvalue2)

------------------- sensitivy list test cases ---------------------

# test case1 --- forward from  '1' and '2'  in  |3| |1|   and change the value only
# 						|4| |2|


force -freeze sim:/forwardunit/MemWbWriteback1 0 0

force -freeze sim:/forwardunit/MemWbWriteback2 0 0

force -freeze sim:/forwardunit/ExMemWriteback1 0 0

force -freeze sim:/forwardunit/ExMemWriteback2 0 0

force -freeze sim:/forwardunit/MemWbRdst1 3'h2 0
force -freeze sim:/forwardunit/MemWbWriteback1 1 0
force -freeze sim:/forwardunit/MemWbRdst2 3'h2 0
force -freeze sim:/forwardunit/MemWbWriteback2 1 0

run 
force -freeze sim:/forwardunit/WbValue2 16'h0012 0

run 



# test case2 --- forward from  '1' and '2' and 3 in  |3| |1|   and change the value only
# 						     |4| |2|


force -freeze sim:/forwardunit/MemWbWriteback1 0 0

force -freeze sim:/forwardunit/MemWbWriteback2 0 0

force -freeze sim:/forwardunit/ExMemWriteback1 0 0

force -freeze sim:/forwardunit/ExMemWriteback2 0 0

force -freeze sim:/forwardunit/MemWbRdst1 3'h2 0
force -freeze sim:/forwardunit/MemWbWriteback1 1 0
force -freeze sim:/forwardunit/MemWbRdst2 3'h2 0
force -freeze sim:/forwardunit/MemWbWriteback2 1 0
force -freeze sim:/forwardunit/ExMemRdst1 3'h2 0
force -freeze sim:/forwardunit/ExMemWriteback1 1 0
run 
force -freeze sim:/forwardunit/AluResult1 16'h0013 0

run 


# test case3 --- forward from  '1' and '2' and 3  and '4'in  |3| |1|   and change the value only
# 						     	     |4| |2|


force -freeze sim:/forwardunit/MemWbWriteback1 0 0

force -freeze sim:/forwardunit/MemWbWriteback2 0 0

force -freeze sim:/forwardunit/ExMemWriteback1 0 0

force -freeze sim:/forwardunit/ExMemWriteback2 0 0

force -freeze sim:/forwardunit/MemWbRdst1 3'h2 0
force -freeze sim:/forwardunit/MemWbWriteback1 1 0
force -freeze sim:/forwardunit/MemWbRdst2 3'h2 0
force -freeze sim:/forwardunit/MemWbWriteback2 1 0
force -freeze sim:/forwardunit/ExMemRdst1 3'h2 0
force -freeze sim:/forwardunit/ExMemWriteback1 1 0
force -freeze sim:/forwardunit/ExMemRdst2 3'h2 0
force -freeze sim:/forwardunit/ExMemWriteback2 1 0
run 
force -freeze sim:/forwardunit/AluResult2 16'h0014 0

run 
