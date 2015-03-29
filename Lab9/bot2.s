.data
.align	2
planet_info:	.space	32
sector_info:	.space	256
flag_var:	
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

.text
main:
	# your code goes here
	# for the interrupt-related portions, you'll want to
	# refer closely to example.s - it's probably easiest
	# to copy-paste the relevant portions and then modify them
	# keep in mind that example.s has bugs, as discussed in section
	li	$t0, 0			# golbal sector id from 0 - 63
	li	$t1, 0			# max of dust particles
	li	$t2, 0			# max sector id
	li	$t3, SCAN_MASK
	or	$t3, $t3, 1		
	mtc0	$t3, $12		# enable scan_interrupt
scan_sector:	
        sw      $t0, SCAN_SECTOR
        la      $t4, sector_info	# get addr of sector info
        sw      $t4, SCAN_REQUEST	# store addr of array
	mul	$t5, $t0, 4
	add	$t5, $t5, $t4
wait:
	lw	$t3, flag_var
	beq	$t3, 1, scan_fin
	j	wait
scan_fin:
	lw	$t6, 0($t5)		# number of dust particles
	ble	$t6, $t1, next_sector
	move	$t1, $t6		# update the max of dust particles
	move	$t2, $t0		# update the location of that sector

next_sector:
	add	$t0, $t0, 1		# next_sector
	bne	$t0, 64, scan_sector	# if next_sector <65, scan_sector
move_bot:
	li	$t7, 1			# absolute turn
target_x:
	la	$t0, sector_info
	add	$t0, $t0, $t2
	sw	$t0, SCAN_REQUEST
	lw	$t1, 0($t0)		# target_x		
	lw	$t8, BOT_X		# get bot_x
	beq	$t1, $t8, target_y
	bgt	$t1, $t8, right		# move to the east if t1>t2

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
	add	$t0, $t0, $t2
	sw	$t0, SCAN_REQUEST
	lw	$t4, 4($t0)		# target_y
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
gravity:
	jr	$ra

.kdata		# interrupt handler data (separated just for readability)
chunkIH:	.space 8 # space for two registers
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
	mfc0 	$k0, $13		# Get Cause register, again
	beq	$k0, $zero, done_	# handled all outstanding interrupts
	and 	$a0, $k0, SCAN_MASK	# scan interrupt?
	bne 	$a0, 0, scan_interrupt
	and 	$a0, $k0, ENERGY_MASK	# energy interrupt?
	bne 	$a0, 0, energy_interrupt

	li 	$v0, 4 			# Unhandled interrupt types
	la 	$a0, unhandled_str
	syscall
	j	done_

scan_interrupt:
	la	$t9, flag_var
	li	$t8, 1
	sw	$t8, 0($t9)
	sw 	$a1, SCAN_ACKNOWLEDGE	
	j 	interrupt_dispatch

energy_interrupt:	sw	$a1, ENERGY_ACKNOWLEDGE
	la	$a0, out_of_energy_str
	syscall
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



