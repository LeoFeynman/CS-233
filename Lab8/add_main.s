.data
food:	.asciiz "FOOD"
str:	.asciiz "FREEFOOD"

.align 2
root:	.space 108

.text
main:
	# add more test cases!
	sub	$sp, $sp, 4
	sw	$ra, 0($sp)

	la	$a0, root
	la	$a1, food
	li	$a2, 0
	jal	add_word_to_trie

	la	$a0, root
	la	$a1, str + 4
	jal	lookup_word_in_trie
	move	$a0, $v0
	jal	print_string_and_newline	# FOOD

	lw	$ra, 0($sp)
	add	$sp, $sp, 4
	jr	$ra
