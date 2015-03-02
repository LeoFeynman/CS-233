.data
selfie:
	.asciiz "SELFIE"		# but first, let me take a selfie

.text
main:
	sub	$sp, $sp, 4
	sw	$ra, 0($sp)

	la	$t0, puzzle_1
	sw	$t0, puzzle
	li	$t0, 16
	sw	$t0, num_rows
	sw	$t0, num_columns

	li	$a0, 0
	li	$a1, 5
	jal	get_character
	move	$a0, $v0
	jal	print_char_and_space	# should print 'H'

	li	$a0, 4
	li	$a1, 11
	jal	get_character
	move	$a0, $v0
	jal	print_char_and_space	# should print 'I'

	la	$a0, selfie
	li	$a1, 71
	li	$a2, 79
	jal	horiz_strncmp
	move	$a0, $v0
	jal	print_int_and_space	# should print 76

	la	$a0, selfie
	li	$a1, 0
	li	$a1, 15
	jal	horiz_strncmp
	move	$a0, $v0
	jal	print_int_and_space	# should print 0

	lw	$ra, 0($sp)
	add	$sp, $sp, 4
	jr	$ra
