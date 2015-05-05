.data
.align	2
step:
.word 0
three:		.float	3.0
five:		.float	5.0
PI:		.float	3.141592
F180:		.float	180.0

.align 2
planet_info:	.space	64

.align 2
sector_info:	.space	256

pointer:
.space 4

vplus:
.space 4

flag_var:	
	.space	4
	.word	0
energy_var:
	.space	4
	.word 	0
.align 2
lexicon:
.space 4096

puzzle:
.space 4104

.align 2
solution:
.space 804

particle_cnt:
.space	4
.word	0

# movement memory-mapped I/O
VELOCITY            = 0xffff0010
ANGLE               = 0xffff0014
ANGLE_CONTROL       = 0xffff0018

# coordinates memory-mapped I/O
BOT_X               = 0xffff0020
BOT_Y               = 0xffff0024

# planet memory-mapped I/O
PLANETS_REQUEST     = 0xffff1014

# scanning memory-mapped I/O
SCAN_REQUEST        = 0xffff1010
SCAN_SECTOR         = 0xffff101c

# gravity memory-mapped I/O
FIELD_STRENGTH      = 0xffff1100

# bot info memory-mapped I/O
SCORES_REQUEST      = 0xffff1018
ENERGY              = 0xffff1104

# debugging memory-mapped I/O
PRINT_INT           = 0xffff0080

# interrupt constants
SCAN_MASK           = 0x2000
SCAN_ACKNOWLEDGE    = 0xffff1204
ENERGY_MASK         = 0x4000
ENERGY_ACKNOWLEDGE  = 0xffff1208  
TIMER_MASK         = 0x8000
TIMER_ACKNOWLEDGE  = 0xffff006c
TIMER              = 0xffff001c

# puzzle interface locations 
SPIMBOT_PUZZLE_REQUEST 	= 0xffff1000 
SPIMBOT_SOLVE_REQUEST 	= 0xffff1004 
SPIMBOT_LEXICON_REQUEST 	= 0xffff1008 

# I/O used in competitive scenario 
SB_INTERFERENCE_MASK 	= 0x400
SPIMBOT_INTERFERENCE_ACK = 0xffff1304
SPACESHIP_FIELD_CNT  	= 0xffff110c 


.text
main:
	li	$t0, 0			# iterator 0 - 63
	li	$t1, 0			# max of dust particles
	li	$t2, 0			# correpsonding sector id
	li	$t3, SCAN_MASK
	or	$t3, ENERGY_MASK
	or	$t3, SB_INTERFERENCE_MASK
	or	$t3, $t3, 1		
	mtc0	$t3, $12		# enable scan_interrupt
scan_sector:	
        sw      $t0, SCAN_SECTOR
        la      $t4, sector_info	# get addr of sector info
        sw      $t4, SCAN_REQUEST	# store addr of array
	mul	$t5, $t0, 4
	add	$t5, $t5, $t4
	la	$t4, flag_var
	sw	$0, 0($t4)
wait:
	lw	$t4, energy_var
	beq	$t4, 1, energy_inter
	lw	$t4, flag_var
	beq	$t4, 1, scan_fin
	j	wait
energy_inter:
	sub	$sp, $sp, 40
	sw	$t0, 0($sp)
	sw	$t1, 4($sp)
	sw	$t2, 8($sp)
	sw	$t3, 12($sp)
	sw	$t4, 16($sp)
	sw	$t5, 20($sp)
	sw	$t6, 24($sp)
	sw	$t7, 28($sp)
	sw	$t8, 32($sp)
	sw	$t9, 36($sp)
	sw	$0, VELOCITY
	jal	solve_puzzle
	li	$t0, 10
	sw	$t0, VELOCITY
	lw	$t0, 0($sp)
	lw	$t1, 4($sp)
	lw	$t2, 8($sp)
	lw	$t3, 12($sp)
	lw	$t4, 16($sp)
	lw	$t5, 20($sp)
	lw	$t6, 24($sp)
	lw	$t7, 28($sp)
	lw	$t8, 32($sp)
	lw	$t9, 36($sp)
	add	$sp, $sp, 40
	la	$t4, energy_var
	sw	$0, 0($t4)
	j	wait
scan_fin:
	lw	$t6, 0($t5)		# number of dust particles
	ble	$t6, $t1, next_sector
	move	$t1, $t6		# update the max of dust particles
	move	$t2, $t0		# update the location of that sector

next_sector:
	add	$t0, $t0, 1		# next_sector
	bne	$t0, 64, scan_sector	# if next_sector <65, scan_sector
#----------------sector located & moving bot-------------------#
move_bot:
	li	$t7, 10
	sw	$t7, VELOCITY
	li	$t7, 1			# absolute turn
	div	$t2, $t2, 8
	mfhi	$t9
	mflo	$t2
	mul	$t9, $t9, 37
	add	$t9, $t9, 19		# coord
	move	$t1, $t9		# target_x		
	mul	$t2, $t2, 37
	add	$t2, $t2, 19		# column
	move	$t4, $t2		# target_y

target_x:
	la	$t0, sector_info
	sw	$t0, SCAN_REQUEST				
	lw	$t8, BOT_X		# get bot_x
	beq	$t1, $t8, target_y
	bgt	$t1, $t8, right		# move to the east if t1>t8

	li	$t3, 180		# set orientation to west
	sw	$t3, ANGLE
	sw	$t7, ANGLE_CONTROL	# absolute turn
	j	target_x
right:
	li	$t3, 0			# set orientation to east
	sw	$t3, ANGLE
	sw	$t7, ANGLE_CONTROL	# absolute turn
	j	target_x		# keep adjust x

target_y:
	la	$t0, sector_info
	sw	$t0, SCAN_REQUEST	
	lw	$t5, BOT_Y		# get bot_y
	beq	$t4, $t5, gravity
	bgt	$t4, $t5, down		# move to the south if t4>t5

	li	$t6, 270		# set orientation to north
	sw	$t6, ANGLE
	sw	$t7, ANGLE_CONTROL	# absolute turn
	j	target_y
down:
	li	$t6, 90			# set orientation to south
	sw	$t6, ANGLE
	sw	$t7, ANGLE_CONTROL	# absolute turn
	j	target_y


#----------------------bot arrived & activate field------------------#
gravity:
	li	$t0, 5
	sw	$t0, FIELD_STRENGTH
	li	$t0, 4
	sw	$t0, VELOCITY
	
	li	$t3, SCAN_MASK
	or	$t3, ENERGY_MASK
	or	$t3, SB_INTERFERENCE_MASK
	or	$t3, TIMER_MASK	
	or	$t3, $t3, 1		
	mtc0	$t3, $12		# enable scan_interrupt

	la	$a0, vplus
	sw	$zero, 0($a0)

	li	$t0, 170
	lw	$t1, TIMER
	add	$t0, $t0, $t1
	sw	$t0, TIMER


#-----------------------locating plannet----------------------------#
	li	$t7, 1			# absolute turn
planet_x:
	la	$t0, PLANETS_REQUEST
	la	$t1, planet_info
	sw	$t1, 0($t0)		# store addr		
	lw 	$t1, 0($t1)		# get planet_x
	lw	$t2, BOT_X		# get bot_x
	beq	$t1, $t2, release
	bgt	$t2, $t1, left		# move to the east if t1>t2

	li	$t3, 0			# set orientation to east
	sw	$t3, ANGLE
	sw	$t7, ANGLE_CONTROL	# absolute turn
	j	planet_y

left:
	li	$t3, 180		# set orientation to west
	sw	$t3, ANGLE
	sw	$t7, ANGLE_CONTROL	# absolute turn
	j	planet_y		# keep adjust x

planet_y:
	la	$t0, PLANETS_REQUEST
	la	$t1, planet_info
	sw	$t1, 0($t0)		# store addr
	lw	$t4, 4($t1)		# get planet_y
	lw	$t5, BOT_Y		# get bot_y
	beq	$t4, $t5, release
	bgt	$t5, $t4, up		# move to the south if t4>t5

	li	$t6, 90			# set orientation to south
	sw	$t6, ANGLE
	sw	$t7, ANGLE_CONTROL	# absolute turn
	j	planet_x		# keep adjust y

up:
	li	$t6, 270		# set orientation to north
	sw	$t6, ANGLE
	sw	$t7, ANGLE_CONTROL	# absolute turn
	j	planet_x

#----------------------release the dust------------------#
release:
	li	$t1, SCAN_MASK
	or	$t1, ENERGY_MASK
	or	$t1, SB_INTERFERENCE_MASK
	or	$t1, $t1, 1		
	mtc0	$t1, $12		# enable scan_interrupt
				
	la	$t1, planet_info
	sw	$t1, 0($t0)		# store addr		
	lw 	$t1, 0($t1)		# get planet_x
	lw	$t2, BOT_X		# get bot_x
	bne	$t1, $t2, planet_x

	la	$t1, planet_info
	sw	$t1, 0($t0)		# store addr	
	lw	$t4, 4($t1)		# get planet_y
	lw	$t5, BOT_Y		# get bot_y
	
	bne	$t4, $t5, planet_y
	li	$t9, 0
	sw	$t9, FIELD_STRENGTH	# turn off bot's gravity
	j	main

solve_puzzle:
	la   $t0, solution
	add  $t0, $t0, 4
	la   $t1, pointer	
	sw   $t0, ($t1)
    sub    $sp, $sp, 16
    sw    $ra, 0($sp)
    sw    $s0, 4($sp)
    sw    $s1, 8($sp)
    sw	  $s2, 12($sp)
    la    $t0, lexicon
    sw    $t0, SPIMBOT_LEXICON_REQUEST    # request lexicon
    lw    $s1, 0($t0)        # lexicon_size
    add   $s0, $t0, 4        # &lexical_items
    la    $s2, puzzle
    sw    $s2, SPIMBOT_PUZZLE_REQUEST 
search:
    beq    $s1, $0, search_done
    # save stack
	sub	$sp,	$sp,	12
	sw	$a0,	0($sp)
	sw	$a1,	4($sp)
	sw	$a2,	8($sp)
	lw	$a0, 	0($s0)
	lw	$a1,	0($s2)#rows
	lw	$a2,	4($s2)#columns
    jal    FindWords       
	lw	$a0,	0($sp)
	lw	$a1,	4($sp)
	lw	$a2,	8($sp)
	add	$sp,	$sp,	12
    sub    $s1, $s1, 1
    add    $s0, $s0, 4        # next word

	la     $t7, solution
	lw     $t7, 0($t7)
	bge    $t7, 17, search_done
    j    search
search_done:

    la    $t7, solution
    sw    $t7, SPIMBOT_SOLVE_REQUEST
    sw    $0, 0($t7)
    lw    $ra, 0($sp)
    lw    $s0, 4($sp)
    lw    $s1, 8($sp)
    lw	  $s2, 12($sp)
    add   $sp, $sp, 16
    jr    $ra

FindWords:
	sub	$sp, $sp, 32
	sw	$ra, 0($sp)
	sw	$s0, 4($sp)	
	sw	$s1, 8($sp)
	sw	$s2, 12($sp)
	sw	$s3, 16($sp)
	sw	$s4, 20($sp)
	sw	$s5, 24($sp)
	sw	$s6, 28($sp)
	la	$s5, solution	# &solution
	la  $s6, pointer
	lw  $s6, 0($s6)
	#lw	$s6, 0($s5)
	#mul	$s6, $s6, 8
	#add	$s6, $s6, 4
	#add	$s6, $s6, $s5
	li	$s4, 0	# num_words
	li	$s0, 0	# i = 0
	move	$t1, $a0	# &word = lexicon
	li	$s3, 0	# size = len
size1:
	lb	$t0, 0($t1)
	beq	$t0, $0, i_loop	
	add	$s3, $s3, 1	# size++
	add	$t1, $t1, 1
	j	size1
i_loop:#(j = s0)
	li	$s1, 0	# j = 0
	#la	$t3, puzzle_1
	move	$t3,	$a1
	bge	$s0, $t3, i_done
j_loop:#(j = s1)
	li	$s2, 0	# k = 0
	move	$t4,	$a2
	bge	$s1, $t4, j_done
	move	$t3, $a2
	mul	$t3, $t3, $s0	
	add	$t3, $t3, $s1	# puzzle[i][j]
	la	$t4,	puzzle
	add	$t4,	$t4,	8
	add	$t3,	$t3,	$t4
	lb	$t3,	0($t3)
	lb	$t4, 0($a0)	# word[0]
	bne	$t3, $t4, k_done

k_loop:#(j = s2)
	la	$t0, step
	sw	$0, 0($t0)

	li	$v0,	-1
	li	$v1,	-1

	li	$t5, 4
	bge	$s2, $t5, k_done
	
	# a0 not changed
	sub $sp, $sp,   16
	sw	$a0,	0($sp)
	sw	$a1,	4($sp)
	sw	$a2,	8($sp)
	sw	$a3,	12($sp)
	
	move	$a1,	$s0
	move	$a2,	$s1
	move	$a3,	$s2
	jal	dfs
	lw	$a0,	0($sp)
	lw	$a1,	4($sp)
	lw	$a2,	8($sp)
	lw	$a3,	12($sp)
	add $sp, $sp,   16
	lw	$t0, step($zero)
	sub	$t0,	$t0,	1
	bne	$t0, $s3, if_done
	la	$t0, puzzle
	add	$t0,	$t0,	8
	move	$t0,	$a2
	mul	$v0, $s0, $t0	# i * column
	add	$v0, $v0, $s1	# i * column + j = start
inner_if:
	bne	$s2, $0, not_right
	add	$v1, $v0, $s3	# start + len
	sub	$v1, $v1, 1	# start + len - 1
	#put v0, v1 into solution 
	beq	$v0, $v1, not_right	
	lw	$s4, 0($s5)
	add	$s4, $s4, 1	# num_words++
	sw	$s4, 0($s5)
	sw	$v0, 0($s6)	# save v0	
	sw	$v1, 4($s6)	# save v1
	add	$s6, $s6, 8	# space for next v0 and v1
	sw  $s6, pointer
	j	if_done
not_right:
	li	$t1, 1
	bne	$s2, $t1, not_left
	sub	$v1, $v0, $s3	# start - len
	add	$v1, $v1, 1	# start - len + 1
	#put v0, v1 into solution 
	beq	$v0, $v1, not_left
	lw	$s4, 0($s5)
	add	$s4, $s4, 1	# num_words++
	sw	$s4, 0($s5)
	sw	$v0, 0($s6)	# save v0	
	sw	$v1, 4($s6)	# save v1
	add	$s6, $s6, 8	# space for next v0 and v1
	sw  $s6, pointer
	j	if_done
not_left:
	li	$t1, 2
	bne	$s2, $t1, not_down
	add	$v1, $s0, $s3	# i + len
	sub	$v1, $v1, 1	# i + len - 1
	mul	$v1, $v1, $a2	
	add	$v1, $v1, $s1	# end
	#put v0, v1 into solution
	beq	$v0, $v1, not_down
	lw	$s4, 0($s5)
	add	$s4, $s4, 1	# num_words++
	sw	$s4, 0($s5)
	sw	$v0, 0($s6)	# save v0	
	sw	$v1, 4($s6)	# save v1
	add	$s6, $s6, 8	# space for next v0 and v1
	sw  $s6, pointer
	j	if_done
not_down:
	li	$t1, 3
	bne	$s2, $t1, if_done
	sub	$v1, $s0, $s3	# i - len
	add	$v1, $v1, 1	# i - len + 1
	mul	$v1, $v1, $a2
	add	$v1, $v1, $s1	# end
	#put v0, v1 into solution
	beq	$v0, $v1, if_done
	lw	$s4, 0($s5)
	add	$s4, $s4, 1	# num_words++
	sw	$s4, 0($s5)
	sw	$v0, 0($s6)	# save v0	
	sw	$v1, 4($s6)	# save v1
	add	$s6, $s6, 8	# space for next v0 and v1 
	sw  $s6, pointer
	j	if_done

if_done:
	add	$s2, $s2, 1	# k++
	j	k_loop
k_done:
	add	$s1, $s1, 1	# j++
	j	j_loop
j_done:
	
	add	$s0, $s0, 1	# i++
	j	i_loop
i_done:
	lw	$ra, 0($sp)
	lw	$s0, 4($sp)	
	lw	$s1, 8($sp)
	lw	$s2, 12($sp)
	lw	$s3, 16($sp)
	lw	$s4, 20($sp)
	lw	$s5, 24($sp)
	lw	$s6, 28($sp)
	add	$sp, $sp, 32
	j	$ra

dfs:
	sub	$sp, $sp, 12
	sw	$ra, 0($sp)
	sw	$s0, 4($sp)
	sw	$s1, 8($sp)
	li	$s1, 0	# counter
	lw	$s0, step	# $t0 step
	add	$s0, $s0, 1	# step++
	la	$t1, step
	sw	$s0, 0($t1)
	move	$t1, $a0	# &str
size:
	lb	$t0, 0($t1)
	beq	$t0, $0, if1_loop
	add	$s1, $s1, 1	# counter++
	add	$t1, $a0, $s1
	j	size
if1_loop:
	sub	$t0,	$s0,	1
	bne	$t0, $s1, if1_done
	jr	$ra
if1_done:
	move	$t0, $a1 	# x = i
	move	$t1, $a2	# y = j
	bne	$a3, $0, not_right2
	add	$t1, $t1, 1	# y = j+1
	j	if2_loop
not_right2:
	li	$t2, 1
	bne	$a3, $t2, not_left2
	sub	$t1, $t1, 1	# y = j-1
	j	if2_loop
not_left2:
	li	$t2, 2
	bne	$a3, $t2, not_down2
	add	$t0, $t0, 1	# x = i+1
	j	if2_loop
not_down2:
	li	$t2, 3
	bne	$a3, $t2, if2_loop
	sub	$t0, $t0, 1	# x = i-1
	j	if2_loop

if2_loop:
	blt	$a1, $0, if2_done
	la	$t7, puzzle
	lw	$t7, 4($t7)	#columns
	move $t3, $t7
	bge	$a1, $t3, if2_done
	blt	$a2, $0, if2_done
	move $t3, $t7
	bge	$a2, $t3, if2_done
	add	$t4, $a0, $s0	# &str[step]
	sub	$t4,	$t4, 	1
	lb	$t4, 0($t4)	# str[step]
	la	$t5, puzzle
	add	$t5, $t5,	8
	move $t6, $t7
	mul	$t6, $t6, $a1	# x * columns
	add	$t6, $t6, $a2	# x * columns + y
	add	$t6, $t5, $t6	# map[x][y]
	lb	$t6, 0($t6)
	bne	$t6, $t4, if2_done	# map[x][y] == str[step]
	move	$a1, $t0
	move	$a2, $t1
	jal	dfs
if2_done:
	lw	$ra, 0($sp)
	lw	$s0, 4($sp)
	lw	$s1, 8($sp)
	add	$sp, $sp, 12
	j	$ra

#-------------interrupt handler data (separated just for readability)--------#
.kdata		
chunkIH:	.space 36 # space for two registers
non_intrpt_str: .asciiz "Non-interrupt exception\n"
unhandled_str: .asciiz "Unhandled interrupt type\n"
out_of_energy_str: .asciiz "Out of energy\n"

.ktext	0x80000180
interrupt_handler:
.set noat
	move 	$k1, $at 		# Save $at
.set at
	la 	$k0, chunkIH
	sw 	$a0, 0($k0) 		# Get some free registers
	sw 	$a1, 4($k0) 		# by storing them to a global variable
	mfc0 	$k0, $13 		# Get Cause register
	srl 	$a0, $k0, 2	
	and 	$a0, $a0, 0xf		# ExcCode field
	bne 	$a0, 0, non_intrpt

interrupt_dispatch: 			# Interrupt:
	mfc0	$k0, $13	# Get Cause register, again                 
	beq	$k0, 0, done_	# handled all outstanding interrupts   
  
	and	$a0, $k0, SB_INTERFERENCE_MASK
	bne	$a0, 0, interference_interupt
	and	$a0, $k0, SCAN_MASK
	bne	$a0, 0,	scan_interrupt
	and	$a0, $k0, ENERGY_MASK
	bne	$a0, 0, energy_interrupt
	
	and	$a0, $k0, TIMER_MASK
	bne	$a0, 0, timer_interrupt
	j	done_

scan_interrupt:
	la	$t9, flag_var
	li	$t8, 1
	sw	$t8, 0($t9)
	sw 	$a1, SCAN_ACKNOWLEDGE	
	j 	interrupt_dispatch

energy_interrupt:	sw	$a1, ENERGY_ACKNOWLEDGE
	la	$t9, energy_var
	li	$t8, 1
	sw	$t8, 0($t9)
	j	interrupt_dispatch
interference_interupt:
	sw	$a1, SPIMBOT_INTERFERENCE_ACK
	la	$t9, particle_cnt
	sw	$t9, SPACESHIP_FIELD_CNT
	lw	$t9, 0($t9)
	li	$t8, 10
	blt	$t9, $t8, turn_off
	j	abc
turn_off:
	sw	$0, FIELD_STRENGTH
abc:	
	j	interrupt_dispatch

timer_interrupt:
	sw	$a1, TIMER_ACKNOWLEDGE
	la	$a0, vplus
	lw	$a1, 0($a1)
	add     $a1, $a1, 2
	sw 	$a1, 0($a0)	

	lw	$t8, VELOCITY
	add	$t8, $t8, $a1
	sw	$t8, VELOCITY
	j	interrupt_dispatch

non_intrpt: 
	li 	$v0, 4
	la 	$a0, non_intrpt_str
	syscall 			# print out an error message
	j 	done_

done_:
	la 	$k0, chunkIH
	lw 	$a0, 0($k0) 			# Restore saved registers
	lw 	$a1, 4($k0)
.set noat
	move 	$at, $k1 			# Restore $at
.set at
	eret 				# Return from exception handler


###############################

