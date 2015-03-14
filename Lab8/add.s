## void
## add_word_to_trie(trie_t *trie, const char *word, int index) {
##     char c = word[index];
##     if (c == 0) {
##         trie->word = word;
##         return;
##     }
## 
##     if (trie->next[c - 'A'] == NULL) {
##         trie->next[c - 'A'] = alloc_trie();
##     }
##     add_word_to_trie(trie->next[c - 'A'], word, index + 1);
## }

.globl add_word_to_trie
add_word_to_trie:
	sub	$sp, $sp, 16
	sw	$ra, 0($sp)
	sw	$s0, 4($sp)
	sw	$s1, 8($sp)
	sw	$s2, 12($sp)

awt:
	move	$s0, $a0
	move	$s1, $a1
	move	$s2, $a2

	add	$t0, $s1, $s2		# & word[index]
	lb	$t1, 0($t0)		# c

	bne 	$t1, 0, sec_if		# if(c == 0)
	sw	$s1, 0($s0)		# trie->word = word

	lw	$ra, 0($sp)
	lw	$s0, 4($sp)
	lw	$s1, 8($sp)
	lw	$s2, 12($sp)
	add	$sp, $sp, 16

	jr	$ra			# return

sec_if:
	sub	$t2, $t1, 'A'		# c - A
	mul	$t3, $t2, 4		# 4 * (c - A)
	add	$t4, $s0, 4		# &trie->next[0]
	add	$t4, $t3, $t4		# &trie->next[c-A]
	lw	$a0, 0($t4)
	bne	$a0, $0, awt_rec	# if (trie->next[c - 'A'] == NULL)
	jal	alloc_trie		# alloc_trie()
	move	$a0, $v0
	#sw	$v0, 0($a0)	

awt_rec:
	add	$s2, $s2, 1
	move	$a2, $s2
	move	$a1, $s1
	j	awt
