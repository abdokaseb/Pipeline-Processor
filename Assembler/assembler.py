import numpy as np
import sys
import re

def writeMem(lines,out):
    data = out.readlines()
    out.seek(0)

    column=len(data[5])
    for code,beg in lines:
        print (beg,code)
        data[beg+3]=data[beg+3][0:column-17]+code+'\n'
        print (data[beg+3])
    out.writelines(data)
    out.truncate()

def get_bin(x, n):
    bit_string_list = list(format(abs(x), 'b').zfill(n))
    if(x<0):
        for i in range(len(bit_string_list)):
            bit_string_list[i] = '0' if bit_string_list[i] == '1' else '1'
        bit_string = ''.join(bit_string_list)
        x = int(bit_string,2)+1
        bit_string = format(abs(x), 'b')
    else:
        bit_string = ''.join(bit_string_list)
    return bit_string


def op_decoding(op,operand_dict):
    operand_opcode = ''
    match = re.match(r"(^[Rr][0-7]$)", op, flags=0) # case of the operand @XRn


    if match:
        operand_opcode=operand_dict[op] 
        #print(operand_opcode,"  ",additional_word)
        return operand_opcode
    
    raise ValueError (" no such operand ")
    



def op2_decoding(line, beg, output, debug, opcode_dict,operand_dict):
    line_splitted = (line.replace(',',' ')).split()
    opcode = line_splitted[0]
    op_1 = line_splitted[1]
    op_2 = line_splitted[2]
    output_fisrt_word=''
    output_additional_word=''
    print(opcode+'ldm')
    #print(opcode)
    if opcode in opcode_dict:
        opcode_binary=opcode_dict[opcode]
        print(opcode)
        output_fisrt_word = output_fisrt_word+opcode_binary
    else : 
        print("error   ",line  )
        sys.exit()
    try :
        if opcode =='ldm':
            #print (" in ldm case")
            op_Rdst = op_decoding(op_1,operand_dict)
            output_fisrt_word = output_fisrt_word+op_Rdst+"000"
            output_additional_word = get_bin(int(op_2,16),16)

        elif opcode == 'shl' or opcode == 'shr':
            print(" in shl case")
            op_Rdst = op_decoding(op_1, operand_dict)
            value = get_bin(int(op_2,16), 5)

            output_fisrt_word = output_fisrt_word+op_Rdst+"000"+value
        else:
            #print(" in else case")

            op_Rsrc = op_decoding(op_1, operand_dict)
            op_Rdst = op_decoding(op_2, operand_dict)
            #print (op_1,op_2)
            output_fisrt_word = output_fisrt_word+op_Rdst+op_Rsrc
            #print (output_fisrt_word)
        if (output_additional_word==''):
            #print(output_fisrt_word, (output_fisrt_word.ljust(16, '0')))
            return [(output_fisrt_word.ljust(16,'0'),beg)]
        else:
            return [(output_fisrt_word.ljust(16,'0'), beg),(output_additional_word.ljust(16,'0'), beg+1)]

    
    except ValueError as err :
        print (err ,"in line", line)
        sys.exit()


def op1_decoding(line, beg, output, debug, opcode_dict,operand_dict):
    line_splitted = (line.replace(',',' ')).split()
    opcode = line_splitted[0]
    op_1 = line_splitted[1]
    output_fisrt_word=''

    #print(opcode)
    if opcode in opcode_dict:
        opcode=opcode_dict[opcode]
        output_fisrt_word = output_fisrt_word+opcode
    else : 
        print("error   ",line  )
        sys.exit()
    try :
        op_Rdst = op_decoding(op_1, operand_dict)
        output_fisrt_word = output_fisrt_word+op_Rdst
        
        return [(output_fisrt_word.ljust(16,'0'),beg)]

    
    except ValueError as err :
        print (err ,"in line", line)
        sys.exit()



    
def get_tables():
    f=open("./codes.txt",'r')
    lines=f.readlines()
    operand={}
    opcode ={}
    for i in range(0,8):
        line=lines[i]
        line = re.sub(' +', ' ', line)
        line =line.replace("\n",'')
        key, space, value = line.partition(' ')
        operand[key]=value
    for i in range (8,35):
        line = lines[i]
        line = re.sub(' +', ' ', line)
        line = line.replace("\n", '')
        key, space, value = line.partition(' ')
        print (value+"value")
        opcode[key] = value

    f.close()
    return opcode,operand

def generate_opcode(lines_with_type,debug):
    output =[]
    opcode,operand=get_tables()
    for i in range (0,len(lines_with_type)):
        line,line_type,beg = lines_with_type[i]
        debug.writelines(line+"  address  "+str(beg))
        if line_type == "2op" :
            instructions_words=op2_decoding(line,beg,output,debug,opcode,operand)
            output = output+instructions_words
            debug.writelines(
                ["\n%s (address in hex = 0x%x)  \n\n" % x for x in instructions_words])
        elif line_type == "1op" :
            instructions_words = op1_decoding(
                line, beg, output, debug, opcode, operand)
            output = output+instructions_words
            debug.writelines(
                 ["\n%s (address in hex = 0x%x)  \n\n" % x for x in instructions_words])
        elif line_type == "hex":
            value = get_bin(int(line,16), 32)
            instructions_words = [(value[16:32], beg), (value[0:16], beg+1)]
            output=output+instructions_words
            debug.writelines(
                 ["\n%s (address in hex = 0x%x)  \n\n" % x for x in instructions_words])
        elif line_type == "nop_setc_clrc_rte_rti":
            line=line.replace(' ','')
            if line in opcode :
               instructions_words = opcode[line]
               instructions_words = [(instructions_words.ljust(16, '0'), beg)]
               output = output+instructions_words
               debug.writelines(
                    ["\n%s (address in hex = 0x%x)  \n\n" % x for x in instructions_words])
            else :
                print (" no such instruction "+line)
                sys.exit()

    return output


def count_words(input_str,beg,output):
    # two operand instrcutions

    # instruction on forrmat op r1,r2
    op_2 = r"(^[a-zA-Z]{0,1}[a-zA-Z]{0,1}[a-zA-Z][a-zA-Z]\s[rR][0-7]\s{0,1},\s{0,1}[rR][0-7]\s{0,1}$|^([lL][dD][mM]|[sS][hH][lL]|[sS][hH][rR])\s[rR][0-7]\s{0,1},\s{0,1}([0-9a-fA-F]+)\s{0,1}$)"
    # any instruction on format 3char + space + manycharacter (branch or 1operand)
    op_1 = r"(^[a-zA-Z]{0,1}[a-zA-Z]{0,1}[a-zA-Z][a-zA-Z]\s[rR][0-7]\s{0,1}$)"
    # any instruction on format 3char or 4char only with no parameters
    nop = r"(^[a-zA-Z]{0,1}[a-zA-Z][a-zA-Z][a-zA-Z]\s{0,1}$)"

    org = r"(^\.[oO][rR][gG]\s{0,1}[0-9a-fA-F]+$)"

    hex_num = r"(^\s{0,1}[0-9a-fA-F]+$)"
    count=beg+1

    if re.match(op_2, input_str, flags=0):
        #print(" 2 operand instructions")
        new_str = input_str.replace(" ", "")

        if (new_str[0:3]=="ldm"):
            count=count+1
            
        output.append((input_str,"2op",beg))

    elif re.match(nop, input_str, flags=0):
        #print(" no operand or rts or iret")
        if(len(input_str.split())<2 ):
            output.append((input_str, "nop_setc_clrc_rte_rti",beg))  
        else:
            raise ValueError('A syntx error', input_str)

    elif re.match(op_1, input_str, flags=0):

        output.append((input_str, "1op",beg))
    elif re.match(org, input_str, flags=0):
        #output.append((input_str, "org",beg))
        count=int((input_str.split())[1], 16)

    elif re.match(hex_num, input_str, flags=0):
        output.append((input_str, "hex",beg))
    else: 
        raise ValueError('A syntx error', input_str)

    return count


def assemblerMips(lines, debug):
    ##################################ss###################
    # remove all white spaces except spaces from each line and remove comments
    new_lines = []   # after remove comments and newlines;
    lines_with_type = []  # pair of line with type of command
    output = []    # output op code (tuples of opcode and address)
    debug.writelines("------------------- preprocessing --------------"+'\n')

    for i in range(0, len(lines)):
        head, semicomma, comment = lines[i].partition('#')
        head = ' '.join(head.split())
        print(head)
        if (head != ''):
            new_lines.append(head.lower())
            debug.writelines(head.lower()+'\n')

    debug.writelines(
        "------------------- end preprocessing  --------------"+'\n')


    #######################################################
    # to determine address of each line and check if there is invalid instructions type
    beg = 0
    #######################################################
    debug.writelines(
            "------------------- addresses --------------"+'\n')

    for i in range (len(new_lines)):
        try:
            beg = count_words(new_lines[i], beg, lines_with_type)
        except ValueError as err:
            print(err.args)
            sys.exit()
    
    debug.writelines(
        ["(instruction = %s) (instruction type = %s) (address in hex = 0x%x)  \n\n" % x for x in lines_with_type])
    debug.writelines("-------------------"+'\n')

    output=generate_opcode(lines_with_type, debug)

    debug.writelines("--------------------"+'\n')
    debug.writelines("successful"+'\n')
    
    return output

def main():
    #input_fil_name = input("input filename:")              ---
    #output_fil_name = input("output filename:")            ---
    #debug_fil_name = input("debug filename:")              ---
    working_dir = ".\\testcases\\Branch\\"
    if (len(sys.argv)!=4):
        print("Wrong number of parameters")
        sys.exit()
    input_fil_name=sys.argv[1]
    output_fil_name = sys.argv[2]
    debug_fil_name=sys.argv[3]   

    print(input_fil_name+" "+output_fil_name+" "+debug_fil_name)
    try:
        f = open(working_dir+input_fil_name, 'r')
        lines = f.readlines()
        debug = open(working_dir+debug_fil_name, 'w')
        output = open(working_dir+output_fil_name, "r+")
        out=assemblerMips(lines,debug)
        print(out)
        writeMem(out, output)
        f.close()
        output.close()
        debug.close()
    except IOError:
        print("Could not open or read one of the files:")
        sys.exit()
    
main() 

