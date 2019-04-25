# Pipeline-Processor

## Assembler 
### How to Run 
* in the code in main funtion change the dir variable to where the test case is ex ".\\testcases\\Branch\\"
* python assembler.py Branch.asm mem.mem debug.txt  (where mem.mem is the memory file we want to modify ) (debug.txt is the log file of the process )
* mem.mem is added to git ignore because it is large in the size 
* you must first generate mem.mem so the script can modify it and add it to the dir above 
* properties of mem.mem file are 
  * // memory data file (do not edit the following line - required for mem load use)
  * // instance=/ram/Ram
  * // format=mti addressradix=h dataradix=b version=1.0 wordsperline=1
  * address bits = 20 bits 
  * wordsize = 16 bits 
### Assembling notes
 * in the debug file the instructions are divide into 3 categrioes 1-2 op  2- 1 op 3 - nop_rti_ret_setc , 2 op on the format opcode op1,op2 
   , 1 op on the format opcode op (branch ,one operand instructions) , nop_rti_ret_setc as the name says 
 * the only instruction that have 2 words is ldm
 * memory is word addressable 
 * in teacher assistant test files they assumed the address that we will read it in case of interrupt is 2 and reset address is 0
 
 * i have change SHL Rsrc, Imm to SHL Rdst, Imm
 
 * Rdst in our op code is the first register (the first part after opcode ) 
  
