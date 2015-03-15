## void
## find_words(const char** dictionary, int dictionary_size) {
##     for (int i = 0; i < num_rows; i++) {
##         for (int j = 0; j < num_columns; j++) {
##             int start = i * num_columns + j;
##             int end = (i + 1) * num_columns - 1;
## 
##             for (int k = 0; k < dictionary_size; k++) {
##                 const char* word = dictionary[k];
##                 int word_end = horiz_strncmp(word, start, end);
##                 if (word_end > 0) {
##                     record_word(word, start, word_end);
##                 }
## 
##                 word_end = vert_strncmp(word, i, j);
##                 if (word_end > 0) {
##                     record_word(word, start, word_end);
##                 }
## 
##             }
##         }
##     }
## }

.globl find_words
find_words:
	sub	$sp, $sp, 36
	sw	$ra, 0($sp)
	sw	$s0, 4($sp)
	sw	$s1, 8($sp)
	sw	$s2, 12($sp)
	sw	$s3, 16($sp)
	sw	$s4, 20($sp)
	sw	$s5, 24($sp)
	sw	$s6, 28($sp)
	sw	$s7, 32($sp)
	move	$s6, $a0		# dictionary
	move	$s7, $a1		# dic_size
	li	$s0, 0			# i = 0
loop_i:
	lw	$t0, num_rows		# num_rows
	bge	$s0, $t0, loop_done
	li	$s1, 0			# j = 0

loop_j:	
	lw	$t1, num_columns	# num_columns
	bge	$s1, $t1, loop_ipp
	mul	$s3, $s0, $t1		# i * num_columns
	add	$s3, $s3, $s1		# start = i * num_columns + j

	add	$s4, $s0, 1		# i + 1
	mul	$s4, $s4, $t1		# (i + 1) * num_columns
	sub	$s4, $s4, 1		# end
	li	$s2, 0			# k = 0 

loop_k:
	bge	$s2, $s7, loop_jpp
	mul	$t2, $s2, 4
	add	$t2, $s6, $t2		# & dictionary[k]
	lw	$s5, 0($t2)		# word
	move	$a0, $s5
	move	$a1, $s3
	move	$a2, $s4
	jal	horiz_strncmp
	move	$t3, $v0		# $t3 = word_end
	
	ble	$t3, 0, skip_record	# word_end > 0
	move	$a0, $s5
	move	$a1, $s3
	move	$a2, $t3
	jal	record_word

skip_record:
	move	$a0, $s5
	move	$a1, $s0
	move	$a2, $s1
	jal	vert_strncmp
	move	$t3, $v0		# $t3 = word_end

	ble	$t3, 0, loop_kpp	# word_end > 0
	move	$a0, $s5
	move	$a1, $s3
	move	$a2, $t3
	jal	record_word
	 
loop_kpp:
	add	$s2, $s2, 1		# k++
	j	loop_k

loop_jpp:	
	add	$s1, $s1, 1		# j++
	j	loop_j

loop_ipp:
	add	$s0, $s0, 1		# i++
	j	loop_i

loop_done:
	lw	$ra, 0($sp)
	lw	$s0, 4($sp)
	lw	$s1, 8($sp)
	lw	$s2, 12($sp)
	lw	$s3, 16($sp)
	lw	$s4, 20($sp)
	lw	$s5, 24($sp)
	lw	$s6, 28($sp)
	lw	$s7, 32($sp)
	add	$sp, $sp, 36
	jr	$ra
