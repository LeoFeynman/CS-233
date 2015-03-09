.data
ren:	.asciiz "REN"
rex:	.asciiz "REX"
str:	.asciiz "ARREXIRENT"

# .space zero-initializes
.align 2
node_root:	.space 108
node_r:		.space 108
node_re:	.space 108
node_ren:	.space 108
node_rex:	.space 108

.text

# build our trie for testing purposes
# you should understand how this works and write your own test cases
create_trie:
	la	$t0, node_r
	li	$t1, 'R'
	sub	$t1, $t1, 'A'
	mul	$t1, $t1, 4
	sw	$t0, node_root+4($t1)

	la	$t0, node_re
	li	$t1, 'E'
	sub	$t1, $t1, 'A'
	mul	$t1, $t1, 4
	sw	$t0, node_r+4($t1)

	la	$t0, node_ren
	li	$t1, 'N'
	sub	$t1, $t1, 'A'
	mul	$t1, $t1, 4
	sw	$t0, node_re+4($t1)
	la	$t1, ren
	sw	$t1, 0($t0)

	la	$t0, node_rex
	li	$t1, 'X'
	sub	$t1, $t1, 'A'
	mul	$t1, $t1, 4
	sw	$t0, node_re+4($t1)
	la	$t1, rex
	sw	$t1, 0($t0)

	jr	$ra

main:
	sub	$sp, $sp, 4
	sw	$ra, 0($sp)

	jal	create_trie

	la	$a0, node_root
	la	$a1, str
	jal	lookup_word_in_trie
	move	$a0, $v0
	jal	print_string_and_newline	# (null)

	la	$a0, node_root
	la	$a1, str + 2
	jal	lookup_word_in_trie
	move	$a0, $v0
	jal	print_string_and_newline	# REX

	la	$a0, node_root
	la	$a1, str + 5
	jal	lookup_word_in_trie
	move	$a0, $v0
	jal	print_string_and_newline	# (null)

	la	$a0, node_root
	la	$a1, str + 6
	jal	lookup_word_in_trie
	move	$a0, $v0
	jal	print_string_and_newline	# REN

	lw	$ra, 0($sp)
	add	$sp, $sp, 4
	jr	$ra
