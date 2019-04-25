# Pipeline-Processor

## assembler 
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
  
