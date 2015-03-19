.data
.align	2
planet_info: .space	32
# movement memory-mapped I/O
VELOCITY            = 0xffff0010
ANGLE               = 0xffff0014
ANGLE_CONTROL       = 0xffff0018

# coordinates memory-mapped I/O
BOT_X               = 0xffff0020
BOT_Y               = 0xffff0024

# planet memory-mapped I/O
PLANETS_REQUEST     = 0xffff1014

# debugging memory-mapped I/O
PRINT_INT           = 0xffff0080

.text
main:
	la	$t0, PLANETS_REQUEST
	li	$t7, 1			# absolute turn
target_x:
	la	$t1, planet_info
	sw	$t1, 0($t0)		# store addr		
	lw 	$t1, 0($t1)		# get planet_x
	lw	$t2, BOT_X		# get bot_x
	beq	$t1, $t2, target_y
	bgt	$t1, $t2, right		# move to the east if t1>t2

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
	la	$t1, planet_info
	sw	$t1, 0($t0)		# store addr
	lw	$t4, 4($t1)		# get planet_y
	lw	$t5, BOT_Y		# get bot_y
	beq	$t4, $t5, target_x
	bgt	$t4, $t5, down		# move to the south if t4>t5

	li	$t6, 270		# set orientation to north
	sw	$t6, ANGLE
	sw	$t7, ANGLE_CONTROL	# absolute turn
	j	target_y
down:
	li	$t6, 90			# set orientation to south
	sw	$t6, ANGLE
	sw	$t7, ANGLE_CONTROL	# absolute turn
	j	target_y		# keep adjust y
#check_position:
	#la	$t1, planet_info
	#sw	$t1, 0($t0)		# store addr
	#lw 	$t1, 0($t1)		# get planet_x
	#lw	$t2, BOT_X		# get bot_x
	#bne	$t1, $t2, target_x	# readjust x
	
	#jr	$ra
