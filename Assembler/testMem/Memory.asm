# all numbers in hex format
# we always start by reset signal
#this is a commented line
.ORG 0  #this means the the following line would be  at address  0 , and this is the reset address
10
#you should ignore empty lines

.ORG 2  #this is the interrupt address
100

.ORG 10
in R2        #R2=19 add 19 in R2
inc R1

in R3        #R3=FFFF
inc R1

in R4        #R4=F320
inc R1

LDD R1,R2     #R1=3 and Mem[R2] = R1 #should be replaced with std
inc R1

STD R2,R5     #R5 = Mem[R2]; = 3 #should be replaced with ldd
inc R1

PUSH R1      #SP=FFFFFFFE,M[FFFFFFFF]=5
inc R1

PUSH R2      #SP=FFFFFFFD,M[FFFFFFFE]=19
inc R1

inc R1 
dec R2 

inc R1 
dec R2 

POP R1       #SP=FFFFFFFE,R1=19
inc R7  # r1 causes load and use

POP R2       #SP=FFFFFFFF,R2=5
inc R7 # r1 causes load and use

STD R3,R7    #R7 = Mem[R3] = 5 #should be replaced with ldd
inc R1