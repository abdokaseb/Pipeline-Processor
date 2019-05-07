.ORG 0
10

.ORG 2
100

.ORG 10
#Start Draw
LDM R1, 666
CALL R1


#draw generic line
.ORG 700
    #start at R5, added to R4, for R3 time, value in R2
    #use R1,R6
    LDM R6, 707
    STD R2, R5 
    ADD R4, R5
    DEC R3
    JZ R6
    JMP R1
    RET 


#draw horizental line
.ORG 70A
    #start at R5, for R3 time, value in R2
    LDM R1, 700

    MOV R3, R7
    LDM R4, 1
    CALL R1

    MOV R7, R3
    SUB R5, R7
    MOV R7, R5 
    LDM R7, 13
    ADD R7, R5
    MOV R3, R7
    CALL R1

    MOV R7, R3
    SUB R5, R7
    MOV R7, R5 
    LDM R7, 13
    ADD R7, R5
    CALL R1

    RET

# draw the L
.ORG 722
    #draw generic line
    LDM R1, 700
    LDM R5, 169 
    LDM R4, 13
    LDM R3, 12
    LDM R2, AAAA
    CALL R1

    #draw horizental line
    LDM R1, 70A
    LDM R5, 2BF
    LDM R3, 7
    LDM R2, AAAA
    CALL R1

    RET

# Draw O
.ORG 738
    #draw generic line
    LDM R1, 700
    LDM R5, 1BD
    LDM R4, 13
    LDM R3, D
    LDM R2, AAAA
    CALL R1

    #draw generic line
    LDM R5, 1C3
    LDM R4, 13
    LDM R3, D
    LDM R2, AAAA
    CALL R1

    LDM R2, AAAA

    #upper
    LDM R5, 174
    STD R2, R5 

    LDM R5, 187
    STD R2, R5 

    LDM R5, 199
    STD R2, R5 

    LDM R5, 19B
    STD R2, R5 

    LDM R5, 1AB
    STD R2, R5 

    LDM R5, 1AF
    STD R2, R5 

    LDM R2, 00AA
    LDM R5, 186
    STD R2, R5 

    LDM R2, AA00
    LDM R5, 188
    STD R2, R5 

    #lower
    LDM R2, AAAA
    LDM R5, 2F0
    STD R2, R5 

    LDM R5, 2DD
    STD R2, R5 

    LDM R5, 2C9
    STD R2, R5 

    LDM R5, 2CB
    STD R2, R5 

    LDM R5, 2B5
    STD R2, R5 

    LDM R5, 2B9
    STD R2, R5 

    LDM R2, 00AA
    LDM R5, 2DC
    STD R2, R5 

    LDM R2, AA00
    LDM R5, 2DE
    STD R2, R5 

    RET

# draw the E
.ORG 78A
    # upper line
    LDM R1, 70A
    LDM R5, 35F
    LDM R3, 7
    LDM R2, AAAA
    CALL R1


    # vertical line
    LDM R1, 700
    LDM R5, 35F
    LDM R4, 13
    LDM R3, 15
    LDM R2, AAAA
    CALL R1

    # down line
    LDM R1, 70A
    LDM R5, 4C8
    LDM R3, 7
    LDM R2, AAAA
    CALL R1


    # Middel line
    LDM R1, 70A
    LDM R5, 40A
    LDM R3, 6
    LDM R2, AAAA
    CALL R1

    RET

# DRAW V 
.ORG 600
    LDM R1, 700
    LDM R4, 13

    LDM R5, 357
    LDM R3, 4
    LDM R2, AAAA
    CALL R1

    LDM R5, 35D
    LDM R3, 4
    LDM R2, AAAA
    CALL R1

    LDM R3, 5

    LDM R5, 3A3
    LDM R2, 00AA
    CALL R1

    LDM R3, 5
    LDM R5, 3A8
    CALL R1

    LDM R3, 5
    LDM R5, 3A4
    LDM R2, AA00
    CALL R1

    LDM R3, 5
    LDM R5, 3A9
    CALL R1

    LDM R3, 5
    LDM R5, 403
    LDM R2, 0AAA
    CALL R1

    LDM R3, 5
    LDM R5, 407
    CALL R1

    LDM R3, 5
    LDM R5, 462
    LDM R2, 00AA
    CALL R1

    LDM R3, 5
    LDM R5, 466
    LDM R2, AA00
    CALL R1

    LDM R2, AAA0
    LDM R5, 4AF
    STD R2, R5 

    LDM R2, 0AAA
    LDM R5, 4B1
    STD R2, R5 

    LDM R2, AAAA

    LDM R5, 4C2
    STD R2, R5 

    LDM R5, 4C4
    STD R2, R5 

    LDM R5, 4D5
    STD R2, R5 

    LDM R5, 4D6
    STD R2, R5 

    LDM R5, 4D7
    STD R2, R5 

    LDM R5, 4E9
    STD R2, R5 

    RET





# Start Draw
.ORG 666
    # draw the L
    LDM R1, 722
    CALL R1

    # draw the O
    LDM R1, 738
    CALL R1

    # draw the E
    LDM R1, 78A
    CALL R1

    # draw the V
    LDM R1, 600
    CALL R1
    RET




