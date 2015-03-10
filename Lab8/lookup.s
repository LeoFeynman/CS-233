## const char *
## lookup_word_in_trie(trie_t *trie, const char *word) {
##     if (trie == NULL) {
##         return NULL;
##     }
## 
##     if (trie->word) {
##         return trie->word;
##     }
## 
##     int c = *word - 'A';
##     if (c < 0 || c >= 26) {
##         return NULL;
##     }
## 
##     trie_t *next_trie = trie->next[c];
##     word ++;
##     return lookup_word_in_trie(next_trie, word);
## }

.globl lookup_word_in_trie
lookup_word_in_trie:
	bne	$a0, $0, check_word	# trie ==  NULL
	li	$v0, 0
	jr	$ra

check_word:
	lw	$t0, 0($a0)		# trie->word
	beq	$t0, $0, int_c	
	move	$v0, $t0
	jr	$ra

int_c:
	lb	$t1, 0($a1)		# *word
	sub 	$t2, $t1, 'A'		# c = *word - 'A'
	bge	$t2, $0, int_blt	# c < 0
	li	$v0, 0
	jr	$ra

int_blt:
	li	$t3, 26			# 26
	blt	$t2, $t3, ret_rec	# c >= 26
	li	$v0, 0
	jr	$ra

ret_rec:
	add	$t5, $a0, 4		# & trie->next[0]
	mul	$t4, $t2, 4		# c * 4
	add	$t5, $t4, $t5		# & trie->next[c]
	lw	$a0, 0($t5)		# trie->next[c]
	add	$a1, $a1, 1		# word ++	
	j	lookup_word_in_trie


	
