# syscall constants
PRINT_INT = 1
PRINT_CHAR = 11
PRINT_STRING = 4

.data
null_str: .asciiz "(null) "
.align 2
test0:	.word	p0x22ff050	p0x22ff030
p0x22ff030:	.word	12
p0x22ff050:	.word	p0x22ff090	p0x22ff070
p0x22ff070:	.word	50
p0x22ff090:	.word	0	p0x22ff0b0
p0x22ff0b0:	.word	4
.align 2
test1:	.word	p0x22ff110	p0x22ff0f0
p0x22ff0f0:	.word	80
p0x22ff110:	.word	p0x22ff150	p0x22ff130
p0x22ff130:	.word	93
p0x22ff150:	.word	p0x22ff190	p0x22ff170
p0x22ff170:	.word	6
p0x22ff190:	.word	p0x22ff1d0	p0x22ff1b0
p0x22ff1b0:	.word	54
p0x22ff1d0:	.word	p0x22ff210	p0x22ff1f0
p0x22ff1f0:	.word	53
p0x22ff210:	.word	0	p0x22ff230
p0x22ff230:	.word	24


.text
# print int and space ##################################################
#
# argument $a0: number to print
# returns       nothing

print_int_and_space:
    li      $v0, PRINT_INT  # load the syscall option for printing ints
    syscall         # print the number

    li      $a0, ' '        # print a blank space
    li      $v0, PRINT_CHAR # load the syscall option for printing chars
    syscall         # print the char
    
    jr      $ra     # return to the calling procedure

# print string ########################################################
#
# argument $a0: string to print
# returns       nothing

print_string:
    li      $v0, PRINT_STRING   # print string command
    syscall                 # string is in $a0
    jr      $ra

# print newline ########################################################
#
# no arguments
# returns       nothing

print_newline:
    li      $a0, '\n'       # print a newline char.
    li      $v0, PRINT_CHAR
    syscall 
    jr      $ra

# print int_ptr_linked_list ########################################################
#
# argument $a0: int_ptr_linked_list to print
# returns       nothing
print_int_ptr_linked_list:
    sub     $sp, $sp, 8
    sw      $ra, 0($sp)
    sw      $s0, 4($sp)
    move    $s0, $a0

    bne     $s0, $0, pipll_loop
    la      $a0, null_str
    jal     print_string

pipll_loop:
    beq     $s0, $0, pipll_end
    lw      $t0, 4($s0)
    lw      $a0, 0($t0)
    jal     print_int_and_space
    lw      $s0, 0($s0)
    j       pipll_loop
pipll_end:
    jal     print_newline
    lw      $ra, 0($sp)
    lw      $s0, 4($sp)
    add     $sp, $sp, 8
    jr      $ra
# main function ########################################################
#
#  this will test 'increment_linked'
#
#########################################################################
.globl main
main:
    sub     $sp, $sp, 4
    sw      $ra, 0($sp)     # save $ra on stack

    la      $a0, test0
    li      $a1, 3
    jal     increment_linked
    la      $a0, test0
    jal     print_int_ptr_linked_list
    la      $a0, test1
    li      $a1, 5
    jal     increment_linked
    la      $a0, test1
    jal     print_int_ptr_linked_list

    lw      $ra, 0($sp)
    add     $sp, $sp, 4
    jr      $ra