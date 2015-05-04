.data
.align 2
step:
.word 0

sector_array:
.space 256

current_sector:
.space 4

max_index:
.space 4

max:
.space 4

scan_done:
.space 4

first_hit:
.space 4

pointer:
.space 4

.align 2
planet_info:
.space 64

.align 2
lexicon:
.space 4096

puzzle:
.space 4104

.align 2
solution:
.space 804

.align 2
NUM_particles:
.space 4

three:	.float	3.0
five:	.float	5.0
PI:	.float	3.141592
F180:	.float  180.0

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

# puzzle interface locations 
SPIMBOT_PUZZLE_REQUEST 		= 0xffff1000 
SPIMBOT_SOLVE_REQUEST 		= 0xffff1004 
SPIMBOT_LEXICON_REQUEST 	= 0xffff1008 

# I/O used in competitive scenario 
SB_INTERFERENCE_MASK 	= 0x400
SPIMBOT_INTERFERENCE_ACK 	= 0xffff1304
SPACESHIP_FIELD_CNT  	= 0xffff110c 

.text

main:
	# first, find the sector with the most dust particles and then move your bot to the sector
	# suck the dust particles??
	# move it to your planet(avoid crossing opponen's planet)
	# do it iteratively

	# enable interrupts
	li	$t4, SCAN_MASK
	or  $t4,	$t4,	ENERGY_MASK
	or	$t4, $t4, 1		# global interrupt enable
	mtc0	$t4, $12		# set interrupt mask (Status register)


	la		$t0,	current_sector
	sw		$zero,	0($t0)
	la		$t0,	max
	sw		$zero,	0($t0)
	la		$t0,	first_hit
	sw		$zero,	0($t0)
infinite: 
	# in this loop, we will keep requesting the max sector(in the interrupt handler, we will move the bot to the sector and then go to our planet)
	# do a for loop for 64 times to find the max sector
	
	move	$t0,	$zero
	bge		$t0,	64,		endFind
Find:
	la		$t2,	scan_done
	sw		$zero,	0($t2)
	
	la		$t1,	sector_array
	sw		$t0,	SCAN_SECTOR($zero)
	sw		$t1,	SCAN_REQUEST($zero)
	# load scan_done to see if request is processed
wait:
	lw		$t3,	0($t2)
	bne		$t3,	1,	wait

	add		$t0,	$t0,	1
	blt		$t0,	64,		Find
endFind:
	j      infinite


.kdata				# interrupt handler data (separated just for readability)
chunkIH:	.space 36	# space for two registers
non_intrpt_str:	.asciiz "Non-interrupt exception\n"
unhandled_str:	.asciiz "Unhandled interrupt type\n"
debug_str:		.asciiz "get to scan_interrupt\n"

.ktext 0x80000180
interrupt_handler:
.set noat
	move	$k1, $at		# Save $at                               
.set at
	la	$k0, chunkIH
	sw	$a0, 0($k0)		# Get some free registers                  
	sw	$a1, 4($k0)		# by storing them to a global variable     
	sw	$v0, 8($k0)
	sw	$t0, 12($k0)
	sw	$t1, 16($k0)
	sw	$t2, 20($k0)
	sw	$t3, 24($k0)
	sw	$t4, 28($k0)
	sw	$t5, 32($k0)
	mfc0	$k0, $13		# Get Cause register                       
	srl	$a0, $k0, 2                
	and	$a0, $a0, 0xf		# ExcCode field                            
	bne	$a0, 0, non_intrpt         

interrupt_dispatch:			# Interrupt:                             
	mfc0	$k0, $13		# Get Cause register, again                 
	beq	$k0, 0, done		# handled all outstanding interrupts     

	and	$a0, $k0, SCAN_MASK
	bne	$a0, 0,	scan_interrupt
	and	$a0, $k0, ENERGY_MASK
	bne	$a0, 0, energy_interrupt
	and	$a0, $k0, SB_INTERFERENCE_MASK
	bne	$a0, 0, interference_interrupt

	# add dispatch for other interrupt types here.

	j	done
energy_interrupt:
	add	$t5,	$zero, 0
	sw	$t5,	VELOCITY($zero)
	sw	$a1,	ENERGY_ACKNOWLEDGE
	jal solve_puzzle
	j	interrupt_dispatch	


scan_interrupt:
	sw	$a1,	SCAN_ACKNOWLEDGE($zero)
	la	$t5,	current_sector
	lw	$t5,	0($t5)
	#last scan, remember to reset all max(0 may be), current_sector
Compare:
	# get current amount, if greater than max, update max
	la	$t1,	sector_array
	mul	$t0,	$t5,	4
	add $t0,	$t0,	$t1
	lw	$t0,	0($t0)
	# get max amount
	la	$t1,	max
	lw	$t2,	0($t1)
	ble $t0,	$t2, smallEq
greater:
	sw	$t0,	0($t1)
	la	$t1,	max_index
	sw	$t5,	0($t1)
smallEq:
	la	$t3,	current_sector
	add	$t5,	$t5,	1
	sw	$t5,	0($t3)

	sub		$t5,	$t5,	1
	bne	$t5,	63,		scan_end

	la $t5,	 max_index
	lw	$t4, 0($t5)
MOVE_BOT:
	add	$t5,	$zero, 10
	sw	$t5,	VELOCITY($zero)
	# calculate (x,y) of the centor of the sector
	add	$t5,	$zero,	8
	div	$t4,	$t5
	mflo	$t0
	mfhi	$t1
	# sector center (x, y) = (t1, t0)
	mul	$t0, $t0, 38 
	add	$t0, $t0, 19
	mul	$t1, $t1, 38
	add $t1, $t1, 19


	# go to (x, y)
	li		$t4,	1
	sub		$sp,	$sp,	36
	sw		$a0,	0($sp)
	sw		$a1,	4($sp)
	sw		$t0,	8($sp)
	sw		$t1,	12($sp)
	sw		$t2,	16($sp)
	sw		$t3,	20($sp)
	sw		$t4,	24($sp)
	sw		$t5,	28($sp)
	sw		$ra,	32($sp)
	move	$a0,	$t1
	move	$a1,	$t0 	
	jal moveToXY
	lw		$a0,	0($sp)
	lw		$a1,	4($sp)
	lw		$t0,	8($sp)
	lw		$t1,	12($sp)
	lw		$t2,	16($sp)
	lw		$t3,	20($sp)
	lw		$t4,	24($sp)
	lw		$t5,	28($sp)
	lw		$ra,	32($sp)
	add		$sp,	$sp,	36

	# now activate the gravity tractor	
	add		$t0,	$zero, 5
	sw		$t0,	FIELD_STRENGTH($zero)
toPlanet:
	add	$t5,	$zero, 6
	sw	$t5,	VELOCITY($zero)
	# now take it to your planet
	# Code copited from bot1.s #################################################################################################
	la		$t0,	PLANETS_REQUEST
	li		$t4,	1
	j LoopAlignX2
debugX:
	move	$t9,	$zero
LoopAlignX2:
	# get x of planet into t1
	la		$t1,	planet_info
	sw		$t1,	0($t0)
	lw		$t5,	32($t1)		# get blue x
	lw		$t1,	0($t1)
	# get x of robot into t2
	lw		$t2,	0xffff0020($zero)
	# compare, if equal then stop aligning
	beq		$t1,	$t2,	EndOfLoopAlignX2
	# compare, if x of robot greater, then go left, otherwise go right
	bgt		$t2,	$t1,	goLeft2
	# code for go right(absolute angle 90)
	li		$t3,	0
	sw		$t3,	0xffff0014($zero)
	sw		$t4,	0xffff0018($zero)
	j 		keeploop
goLeft2:
	# code for go left(absolute angle 270)
	li		$t3,	180
	sw		$t3,	0xffff0014($zero)
	sw		$t4,	0xffff0018($zero)
keeploop:
###################################################if approaching opponent, then align another direction, t3,t5 is available
	bgt		$t2,	$t5,	t2greater
t5greater:
	sub		$t5,	$t5,	$t2
	j diff
t2greater:
	sub		$t5,	$t2,	$t5
diff:
	bgt		$t5,	100,		debugY
###################################################
	j		LoopAlignX2
EndOfLoopAlignX2:
	j LoopAlignY2
debugY:
	move	$t9,	$zero
LoopAlignY2:
	# get y of planet into t1
	la		$t1,	planet_info
	sw		$t1,	0($t0)
	lw		$t5,	36($t1)
	lw		$t1,	4($t1)
	# get y of robot into t2
	lw		$t2,	0xffff0024($zero)
	# compare, if equal then stop aligning
	beq		$t1,	$t2,	EndOfLoopAlignY2
	# compare, if y of robot greater, then go down, otherwise go up
	bgt		$t2,	$t1,	goUp2
	# code for go down(absolute angle 180)
	V 
	sw		$t3,	0xffff0014($zero)
	sw		$t4,	0xffff0018($zero)
keeploop2:
###################################################if approaching opponent, then align another direction, t3,t5 is available
	bgt		$t2,	$t5,	t2greater2
t5greater2:
	sub		$t5,	$t5,	$t2
	j diff2
t2greater2:
	sub		$t5,	$t2,	$t5
diff2:
	bgt		$t5,	100,		debugX
###################################################
	j		LoopAlignY2
EndOfLoopAlignY2:

	# get x of planet into t1
	la		$t1,	planet_info
	sw		$t1,	0($t0)
	lw		$t1,	0($t1)
	# get x of robot into t2
	lw		$t2,	0xffff0020($zero)
	bne		$t1,	$t2,	LoopAlignX2

	# get y of planet into t1
	la		$t1,	planet_info
	sw		$t1,	0($t0)
	lw		$t1,	4($t1)
	# get y of robot into t2
	lw		$t2,	0xffff0024($zero)
	bne		$t1,	$t2,	LoopAlignY2
	# Code copited from bot1.s #################################################################################################




	la		$t0,	current_sector
	sw		$zero,	0($t0)
	la		$t0,	max
	sw		$zero,	0($t0)

	add		$t0,	$zero, 2
	sw		$t0,	VELOCITY
	# now deactivate the gravity tractor	
	add		$t0,	$zero, 0
	sw		$t0,	FIELD_STRENGTH($zero)
scan_end:
	# notify main() that I am done, you can make another request now
	la	$t0,	scan_done
	add	$t1,	$zero,	1	
	sw	$t1,	0($t0)
	j			interrupt_dispatch	# see if other interrupts are waiting

interference_interupt:
	sw  $0		SPIMBOT_INTERFERENCE_ACK
	sw	$zero,	VELOCITY($zero)
	j			interrupt_dispatch		



moveToXY:	# a0 is x, a1 is y,use t0 through t5, and ra of course.
#########################$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
	move	$t1,	$a0
	move	$t0,	$a1
	li		$t4,	1
	# align x first
	# get x of robot into t2
	lw		$t2,	BOT_X($zero)
	beq		$t1,	$t2,	EndOfLoopAlignXF
	# compare, if x of robot greater, then go left, otherwise go right
	bgt		$t2,	$t1,	goLeftF
	# code for go right(absolute angle 0)
	li		$t3,	0
	sw		$t3,	0xffff0014($zero)
	sw		$t4,	0xffff0018($zero)
	j 		LoopAlignXF
goLeftF:
	# code for go left(absolute angle 180)
	li		$t3,	180
	sw		$t3,	0xffff0014($zero)
	sw		$t4,	0xffff0018($zero)
LoopAlignXF:
	# get x of robot into t2
	lw		$t2,	BOT_X($zero)
	# compare, if equal then stop alignin g
	beq		$t1,	$t2,	EndOfLoopAlignXF
	j		LoopAlignXF
EndOfLoopAlignXF:


	# now align y
	# get y of robot into t2
	lw		$t2,	BOT_Y($zero)
	beq		$t0,	$t2,	EndOfLoopAlignYF
	# compare, if y of robot greater, then go down, otherwise go up
	bgt		$t2,	$t0,	goUpF
	# code for go up(absolute angle )
	li		$t3,	90
	sw		$t3,	0xffff0014($zero)
	sw		$t4,	0xffff0018($zero)
	j 		LoopAlignXF
goUpF:
	# code for go left(absolute angle )
	li		$t3,	270
	sw		$t3,	0xffff0014($zero)
	sw		$t4,	0xffff0018($zero)
LoopAlignYF:
	# get Y of robot into t2
	lw		$t2,	BOT_Y($zero)
	# compare, if equal then stop alignin Y
	beq		$t0,	$t2,	EndOfLoopAlignYF
	j		LoopAlignYF
EndOfLoopAlignYF:	

	jr	$ra

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
	sub		$sp,	$sp,	12
	sw		$a0,	0($sp)
	sw		$a1,	4($sp)
	sw		$a2,	8($sp)
	lw		$a0, 	0($s0)
	lw		$a1,	0($s2)#rows
	lw		$a2,	4($s2)#columns
    jal    FindWords       
	lw		$a0,	0($sp)
	lw		$a1,	4($sp)
	lw		$a2,	8($sp)
	add		$sp,	$sp,	12
    sub    $s1, $s1, 1
    add    $s0, $s0, 4        # next word
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
	la	$s5, solution		# &solution
	la  $s6, pointer
	lw  $s6, 0($s6)
	#lw	$s6, 0($s5)
	#mul	$s6, $s6, 8
	#add	$s6, $s6, 4
	#add	$s6, $s6, $s5
	li	$s4, 0			# num_words
	li	$s0, 0			# i = 0
	move	$t1, $a0		# &word = lexicon
	li	$s3, 0			# size = len
size1:
	lb	$t0, 0($t1)
	beq	$t0, $0, i_loop	
	add	$s3, $s3, 1		# size++
	add	$t1, $t1, 1
	j	size1
i_loop:#(j = s0)
	li	$s1, 0			# j = 0
	#la	$t3, puzzle_1
	move	$t3,	$a1
	bge	$s0, $t3, i_done
j_loop:#(j = s1)

	li	$s2, 0			# k = 0
	move	$t4,	$a2
	bge	$s1, $t4, j_done

	lw	$t6, 0($s5)
	li	$t7, 15
	beq	$t6, $t7, i_done

	move	$t3, $a2
	mul	$t3, $t3, $s0		
	add	$t3, $t3, $s1		# puzzle[i][j]
	la	$t4,	puzzle
	add	$t4,	$t4,	8
	add	$t3,	$t3,	$t4
	lb	$t3,	0($t3)
	lb	$t4, 0($a0)		# word[0]
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
	mul	$v0, $s0, $t0		# i * column
	add	$v0, $v0, $s1		# i * column + j = start
inner_if:
	bne	$s2, $0, not_right
	add	$v1, $v0, $s3		# start + len
	sub	$v1, $v1, 1		# start + len - 1
	#put v0, v1 into solution 
	beq	$v0, $v1, not_right	
	lw	$s4, 0($s5)
	add	$s4, $s4, 1		# num_words++
	sw	$s4, 0($s5)
	sw	$v0, 0($s6)		# save v0		
	sw	$v1, 4($s6)		# save v1
	add	$s6, $s6, 8		# space for next v0 and v1
	sw  $s6, pointer
	j	if_done
not_right:
	li	$t1, 1
	bne	$s2, $t1, not_left
	sub	$v1, $v0, $s3		# start - len
	add	$v1, $v1, 1		# start - len + 1
	#put v0, v1 into solution 
	beq	$v0, $v1, not_left
	lw	$s4, 0($s5)
	add	$s4, $s4, 1		# num_words++
	sw	$s4, 0($s5)
	sw	$v0, 0($s6)		# save v0		
	sw	$v1, 4($s6)		# save v1
	add	$s6, $s6, 8		# space for next v0 and v1
	sw  $s6, pointer
	j	if_done
not_left:
	li	$t1, 2
	bne	$s2, $t1, not_down
	add	$v1, $s0, $s3		# i + len
	sub	$v1, $v1, 1		# i + len - 1
	mul	$v1, $v1, $a2	
	add	$v1, $v1, $s1		# end
	#put v0, v1 into solution
	beq	$v0, $v1, not_down
	lw	$s4, 0($s5)
	add	$s4, $s4, 1		# num_words++
	sw	$s4, 0($s5)
	sw	$v0, 0($s6)		# save v0		
	sw	$v1, 4($s6)		# save v1
	add	$s6, $s6, 8		# space for next v0 and v1
	sw  $s6, pointer
	j	if_done
not_down:
	li	$t1, 3
	bne	$s2, $t1, if_done
	sub	$v1, $s0, $s3		# i - len
	add	$v1, $v1, 1		# i - len + 1
	mul	$v1, $v1, $a2
	add	$v1, $v1, $s1		# end
	#put v0, v1 into solution
	beq	$v0, $v1, if_done
	lw	$s4, 0($s5)
	add	$s4, $s4, 1		# num_words++
	sw	$s4, 0($s5)
	sw	$v0, 0($s6)		# save v0		
	sw	$v1, 4($s6)		# save v1
	add	$s6, $s6, 8		# space for next v0 and v1 
	sw  $s6, pointer
	j	if_done

if_done:
	add	$s2, $s2, 1		# k++
	j	k_loop
k_done:
	add	$s1, $s1, 1		# j++
	j	j_loop
j_done:
	
	add	$s0, $s0, 1		# i++
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
	li	$s1, 0		# counter
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
	add	$t1, $t1, 1		# y = j+1
	j	if2_loop
not_right2:
	li	$t2, 1
	bne	$a3, $t2, not_left2
	sub	$t1, $t1, 1		# y = j-1
	j	if2_loop
not_left2:
	li	$t2, 2
	bne	$a3, $t2, not_down2
	add	$t0, $t0, 1		# x = i+1
	j	if2_loop
not_down2:
	li	$t2, 3
	bne	$a3, $t2, if2_loop
	sub	$t0, $t0, 1		# x = i-1
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
#####################################################
sb_arctan:
	li	$v0, 0		# angle = 0;

	abs	$t0, $a0	# get absolute values
	abs	$t1, $a1
	ble	$t1, $t0, no_TURN_90	  

	## if (abs(y) > abs(x)) { rotate 90 degrees }
	move	$t0, $a1	# int temp = y;
	neg	$a1, $a0	# y = -x;      
	move	$a0, $t0	# x = temp;    
	li	$v0, 90		# angle = 90;  

no_TURN_90:
	bgez	$a0, pos_x 	# skip if (x >= 0)

	## if (x < 0) 
	add	$v0, $v0, 180	# angle += 180;

pos_x:
	mtc1	$a0, $f0
	mtc1	$a1, $f1
	cvt.s.w $f0, $f0	# convert from ints to floats
	cvt.s.w $f1, $f1
	
	div.s	$f0, $f1, $f0	# float v = (float) y / (float) x;

	mul.s	$f1, $f0, $f0	# v^^2
	mul.s	$f2, $f1, $f0	# v^^3
	l.s	$f3, three	# load 5.0
	div.s 	$f3, $f2, $f3	# v^^3/3
	sub.s	$f6, $f0, $f3	# v - v^^3/3

	mul.s	$f4, $f1, $f2	# v^^5
	l.s	$f5, five	# load 3.0
	div.s 	$f5, $f4, $f5	# v^^5/5
	add.s	$f6, $f6, $f5	# value = v - v^^3/3 + v^^5/5

	l.s	$f8, PI		# load PI
	div.s	$f6, $f6, $f8	# value / PI
	l.s	$f7, F180	# load 180.0
	mul.s	$f6, $f6, $f7	# 180.0 * value / PI

	cvt.w.s $f6, $f6	# convert "delta" back to integer
	mfc1	$t0, $f6
	add	$v0, $v0, $t0	# angle += delta

	jr 	$ra
#########################$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
non_intrpt:				# was some non-interrupt

	# fall through to done

done:
	la	$k0, chunkIH
	lw	$a0, 0($k0)		# Restore saved registers
	lw	$a1, 4($k0)
	lw	$v0, 8($k0)
	lw	$t0, 12($k0)
	lw	$t1, 16($k0)
	lw	$t2, 20($k0)
	lw	$t3, 24($k0)
	lw	$t4, 28($k0)
	lw	$t5, 32($k0)

.set noat
	move	$at, $k1		# Restore $at
.set at 
	eret






