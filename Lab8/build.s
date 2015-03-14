## trie_t *
## build_trie(const char **wordlist, int num_words) {
##     trie_t *root = alloc_trie();
## 
##     for (int i = 0 ; i < num_words ; i ++) {
##         // start at first letter of each word
##         add_word_to_trie(root, wordlist[i], 0);
##     }
## 
##     return root;
## }

.globl build_trie
build_trie:
	sub	$sp, $sp, 20
	sw	$ra, 0($sp)
	sw	$s0, 4($sp)
	sw	$s1, 8($sp)
	sw	$s2, 12($sp)
	sw	$s3, 16($sp)

	move	$s0, $a0		# wordlist
	move	$s1, $a1		# num_word
	li	$s2, 0			# i = 0

	jal 	alloc_trie		# alloc_trie()
	move	$s3, $v0		# root = alloc_trie

bt_bge:
	bge	$s2, $s1, bt_ret	# i < num_words
	mul	$t2, $s2, 4		# i * 4
	add	$a1, $s0, $t2		# &wordlist[i]
	lw	$a1, 0($a1)
	li	$a2, 0			# index = 0

	move	$a0, $s3
	jal	add_word_to_trie
	add	$s2, $s2, 1		# i++
	j	bt_bge

bt_ret:	
	move	$v0, $s3
	lw	$ra, 0($sp)
	lw	$s0, 4($sp)
	lw	$s1, 8($sp)
	lw	$s2, 12($sp)
	lw	$s3, 16($sp)
	add	$sp, $sp, 20
	jr	$ra
