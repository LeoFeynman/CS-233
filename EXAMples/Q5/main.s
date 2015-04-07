# syscall constants
PRINT_INT = 1
PRINT_CHAR = 11
PRINT_STRING = 4

.data
null_str: .asciiz "(null) "
.align 2
test0:	.word	p0xe86050	p0xe86110	p0xe86030
p0xe86030:	.word	22
p0xe86050:	.word	p0xe86090	p0xe860d0	p0xe86070
p0xe86070:	.word	37
p0xe86090:	.word	0	0	p0xe860b0
p0xe860b0:	.word	4
p0xe860d0:	.word	0	0	p0xe860f0
p0xe860f0:	.word	10
p0xe86110:	.word	p0xe86150	p0xe86190	p0xe86130
p0xe86130:	.word	45
p0xe86150:	.word	0	0	p0xe86170
p0xe86170:	.word	56
p0xe86190:	.word	0	0	p0xe861b0
p0xe861b0:	.word	18
.align 2
test1:	.word	p0xe86210	p0xe863b0	p0xe861f0
p0xe861f0:	.word	93
p0xe86210:	.word	p0xe86250	p0xe86310	p0xe86230
p0xe86230:	.word	20
p0xe86250:	.word	p0xe86290	p0xe862d0	p0xe86270
p0xe86270:	.word	5
p0xe86290:	.word	0	0	p0xe862b0
p0xe862b0:	.word	96
p0xe862d0:	.word	0	0	p0xe862f0
p0xe862f0:	.word	72
p0xe86310:	.word	p0xe86350	p0xe86370	p0xe86330
p0xe86330:	.word	62
p0xe86350:	.word	0	0	0
p0xe86370:	.word	0	0	p0xe86390
p0xe86390:	.word	54
p0xe863b0:	.word	p0xe863f0	p0xe86490	p0xe863d0
p0xe863d0:	.word	21
p0xe863f0:	.word	p0xe86410	p0xe86450	0
p0xe86410:	.word	0	0	p0xe86430
p0xe86430:	.word	29
p0xe86450:	.word	0	0	p0xe86470
p0xe86470:	.word	69
p0xe86490:	.word	p0xe864d0	p0xe864f0	p0xe864b0
p0xe864b0:	.word	97
p0xe864d0:	.word	0	0	0
p0xe864f0:	.word	0	0	p0xe86510
p0xe86510:	.word	53


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


# main function ########################################################
#
#  this will test 'total_tree'
#
#########################################################################
.globl main
main:
    sub     $sp, $sp, 4
    sw      $ra, 0($sp)     # save $ra on stack

    la      $a0, test0
    jal     total_tree
    move    $a0, $v0
    jal     print_int_and_space
    jal     print_newline
    la      $a0, test1
    jal     total_tree
    move    $a0, $v0
    jal     print_int_and_space
    jal     print_newline

    lw      $ra, 0($sp)
    add     $sp, $sp, 4
    jr      $ra