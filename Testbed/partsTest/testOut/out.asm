# all numbers in hex format
# we always start by reset signal
#this is a commented line
.ORG 0  #this means the the following line would be  at address  0 , and this is the reset address
10
#you should ignore empty lines

.ORG 2  #this is the interrupt address
100

.ORG 10
inc R1        #add 5 in R1
dec R2        #add 19 in R2

MoV R2,R3    #R5 = FFFF , flags no change
MoV R1,R4    #R5 = FFFF , flags no change

OUT R1
inc R1

OUT R3
NOP
