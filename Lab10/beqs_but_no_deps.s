.data
array:	.word	1	255	1024	100	200

# every register except $0 starts holding the address of "array"
#
# this is a cheat so that we don't need to implement addi and lui in
# our pipelined machine.

.text
main:   

	lw	$2,  0($20)		# $2 = 1	(0x1)
	lw	$3,  4($20)		# $3 = 255	(0xff)
	lw	$4,  8($20)		# $4 = 1024	(0x400)
	lw	$5, 12($20)		# $5 = 100	(0x64)
	lw	$6, 16($20)		# $6 = 200	(0xc8)

	add	$7, $2, $2		# $7 = 2	(0x2)
	add	$8, $4, $3		# $8 = 1279 (0x4ff)

	sub	$9, $5, $0		# $9 = 100 	(0x64) 
	and	$10, $4, $3		# $10 = 0 	(0x0)

	beq	$9, $5, skip_store

	sw	$8, 0($20)		# never executes
	
skip_store:
	or	$11, $5, $6		# $11 = 236 (0xec)
	slt	$12, $7, $8		# $12 = 1 	(0x1)
	and	$13, $5, $6		# $13 = 64	(0x40)

	beq	$12, $0, skip_branch

	beq	$0, $0, end_branch

skip_branch:
	sub	$14, $6, $5		# $14 = 100	(0x64)

	beq	$0, $0, done

end_branch:
	add	$14, $6, $10		# $14 = 200 (0xc8)

done:
	or	$15, $8, $12		# $15 = 1279 (0x4ff)
