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
inc R1        #add 5 in R1
dec R2        #add 19 in R2
MoV R1,R3    #R5 = FFFF , flags no change
MoV R1,R4    #R5 = FFFF , flags no change
inc R1        #add 5 in R1
inc R2        #add 19 in R2
inc R1        #add 5 in R1
inc R2        #add 19 in R2
MoV R1,R5    #R5 = FFFF , flags no change
MoV R1,R6    #R5 = FFFF , flags no change
inc R1        #add 5 in R1
inc R2        #add 19 in R2
inc R1        #add 5 in R1
inc R2        #add 19 in R2
inc R1        #add 5 in R1
inc R2        #add 19 in R2
inc R1        #add 5 in R1
inc R2        #add 19 in R2
MoV R1,R7    #R5 = FFFF , flags no change
MoV R1,R0    #R5 = FFFF , flags no change
inc R1        #add 5 in R1
inc R2        #add 19 in R2
inc R1        #add 5 in R1
inc R2        #add 19 in R2
#NOP
#NOP
ADD R1,R4    #R4= F325 , C-->0, N-->1, Z-->0
SUB R5,R3    #R4= 0CDA , C-->1, N-->0,Z-->0
AND R6,R2    #R4= 0000 , C-->no change, N-->0, Z-->1
OR  R7,R1    #R1=1D  , C--> no change, N-->0, Z--> 0
SHL R5,2     #R2=64  , C--> 0, N -->0 , Z -->0
SHR R4,3     #R2=0C  , C -->1, N-->0 , Z-->0
Add R2,R3    #R3=0C  (C,N,Z =0)
NOP
