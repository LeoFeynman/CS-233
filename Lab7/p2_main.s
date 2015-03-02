.data
posting:
	.asciiz "POSTING"

.align 2
language:
	.asciiz "LANGUAGE"

.align 2
notaword:
	.asciiz "NOTAWORD"

.text
main:
	sub	$sp, $sp, 4
	sw	$ra, 0($sp)

	la	$t0, puzzle_1
	sw	$t0, puzzle
	li	$t0, 16
	sw	$t0, num_rows
	sw	$t0, num_columns

	la	$a0, posting
	li	$a1, 5
	li	$a2, 2
	jal	vert_strncmp
	move	$a0, $v0
	jal	print_int_and_space	# should print 178

	la	$a0, posting
	li	$a1, 8
	li	$a2, 8
	jal	vert_strncmp
	move	$a0, $v0
	jal	print_int_and_space	# should print 0

	la	$a0, language
	jal	horiz_strncmp_fast
	move	$a0, $v0
	jal	print_int_and_space	# should print 24

	la	$a0, notaword
	jal	horiz_strncmp_fast
	move	$a0, $v0
	jal	print_int_and_space	# should print 0

	lw	$ra, 0($sp)
	add	$sp, $sp, 4
	jr	$ra
