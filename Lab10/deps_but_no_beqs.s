.data
array:	.word	1	255	1024	100	200

# every register except $0 starts holding the address of "array"
#
# this is a cheat so that we don't need to implement addi and lui in
# our pipelined machine.

.text
main:   

	lw	$2,  0($20)	# $2 = 1	(0x1)
	lw	$3,  4($20)	# $3 = 255	(0xff)
	lw	$4,  8($20)	# $4 = 1024	(0x400)
	lw	$5, 12($20)	# $5 = 100	(0x64)
	lw	$6, 16($20)	# $6 = 200	(0xc8)


	add	$7, $2, $6	# $7 = 201	(0xc9)
	add	$8, $4, $3	# $8 = 1279 (0x4ff)

	sub	$9, $8, $2	# $9 = 1278	(0x4fe)
	and	$10, $4, $3	# $10 = 0   (0x0)

	or	$11, $4, $10	# $11 = 1024 (0x400)
