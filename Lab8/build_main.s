.data
str:	.asciiz "FOOBARPOSTINGOESELFIEVERYONERHINOCEROUS"

.text

main:
	# add your own tests!
	# compare output against trie.cpp
	sub	$sp, $sp, 12
	sw	$ra, 0($sp)
	sw	$s0, 4($sp)
	sw	$s1, 8($sp)

	la	$a0, english
	lw	$a1, english_size
	jal	build_trie

	move	$s0, $v0		# root
	la	$s1, str

main_loop:
	lbu	$t0, 0($s1)
	beq	$t0, 0, main_done
	move	$a0, $s0
	move	$a1, $s1
	jal	lookup_word_in_trie
	beq	$v0, 0, main_next
	move	$a0, $v0
	jal	print_string_and_newline

main_next:
	add	$s1, $s1, 1
	j	main_loop

main_done:
	lw	$ra, 0($sp)
	lw	$s0, 4($sp)
	lw	$s1, 8($sp)
	add	$sp, $sp, 12
	jr	$ra
