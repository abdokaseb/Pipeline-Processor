# all numbers in hex format
# we always start by reset signal
#if you don't handle hazards add 3 NOPs
#this is a commented line
.ORG 0  #this means the the following line would be  at address  0 , and this is the reset address
10
#you should ignore empty lines

.ORG 2  #this is the interrupt address.ORG 10
in R1     #R1=30
in R2     #R2=50
in R3     #R3=100
in R4     #R4=300
NOP
and r0,r0  
CALL R1

.ORG 30
JZ R2
RET


.ORG 50
setc
AND R5,R5 #interrupt here
OUT R4
RET

.ORG 300
RTI # get carry flag back  and interrupt here but after decoding of RTI

.ORG 100
JC R4 #clear carry flag
