.text

## int
## vert_strncmp(const char* word, int start_i, int j) {
##     int word_iter = 0;
## 
##     for (int i = start_i; i < num_rows; i++, word_iter++) {
##         if (get_character(i, j) != word[word_iter]) {
##             return 0;
##         }
## 
##         if (word[word_iter + 1] == '\0') {
##             // return ending address within array
##             return i * num_columns + j;
##         }
##     }
## 
##     return 0;
## }

.globl vert_strncmp
vert_strncmp:
	sub	$sp, $sp, 24
	sw	$ra, 0($sp)
	sw	$s0, 4($sp)
	sw	$s1, 8($sp)
	sw	$s2, 12($sp)
	sw	$s3, 16($sp)
	sw	$s4, 20($sp)

	move	$s1, $a0		# *word
	move	$s2, $a1		# start_i
	move	$s3, $a2		# j
	move	$s4, $a1		# i = start_i
	li	$s0, 0			# wi = 0
	
vs_loop:
	lw	$t1, num_rows		# load num_rows
	bge	$s4, $t1, vs_exit	# i < num_rows
	move	$a0, $s4		# i as $a0
	move	$a1, $a2		# j as $a1
	jal	get_character
	move	$t2, $v0		# get_char[i,j]
	add	$t3, $s1, $s0		# *word[word_i]
	lb	$t3, 0($t3)		# word[word_i]
	beq	$t2, $t3, vs_loop2	# second if loop
	li	$v0, 0			
	j	vs_exit

vs_loop2:
	add	$t4, $s0, 1		# wi + 1
	add	$t4, $s1, $t4		# *word[wi+1]
	lb	$t4, 0($t4)		# word[wi+1]
	bne	$t4, $0, vs_add		# add then go back to for loop
	lw	$t5, num_columns
	mul	$v0, $s4, $t5		# i * num_columns
	add	$v0, $v0, $s3		# i * num_columns + 1
	lw	$ra, 0($sp)
	lw	$s0, 4($sp)
	lw	$s1, 8($sp)
	lw	$s2, 12($sp)
	lw	$s3, 16($sp)
	lw	$s4, 20($sp)
	add	$sp, $sp, 24
	jr	$ra

vs_add:
	add	$s4, $s4, 1		# i++
	add	$s0, $s0, 1		# wi++
	j	vs_loop			# back to for loop

vs_exit:
	li	$v0, 0
	lw	$ra, 0($sp)
	lw	$s0, 4($sp)
	lw	$s1, 8($sp)
	lw	$s2, 12($sp)
	lw	$s3, 16($sp)
	lw	$s4, 20($sp)
	add	$sp, $sp, 24
	jr	$ra

## // assumes the word is at least 4 characters
## int
## horiz_strncmp_fast(const char* word) {
##     // treat first 4 chars as an int
##     unsigned x = *(unsigned*)word;
##     unsigned cmp_w[4];
##     // compute different offsets to search
##     cmp_w[0] = x;
##     cmp_w[1] = (x & 0x00ffffff); 
##     cmp_w[2] = (x & 0x0000ffff);
##     cmp_w[3] = (x & 0x000000ff);
## 
##     for (int i = 0; i < num_rows; i++) {
##         // treat the row of chars as a row of ints
##         unsigned* array = (unsigned*)(puzzle + i * num_columns);
##         for (int j = 0; j < num_columns / 4; j++) {
##             unsigned cur_word = array[j];
##             int start = i * num_columns + j * 4;
##             int end = (i + 1) * num_columns - 1;
## 
##             // check each offset of the word
##             for (int k = 0; k < 4; k++) {
##                 // check with the shift of current word
##                 if (cur_word == cmp_w[k]) {
##                     // finish check with regular horiz_strncmp
##                     int ret = horiz_strncmp(word, start + k, end);
##                     if (ret != 0) {
##                         return ret;
##                     }
##                 }
##                 cur_word >>= 8;
##             }
##         }
##     }
##     
##     return 0;
## }

.globl horiz_strncmp_fast
horiz_strncmp_fast:
	sub	$sp, $sp, 48
	sw	$ra, 0($sp)
	sw	$s0, 4($sp)			
	sw	$s1, 20($sp)
	sw	$s2, 24($sp)
	sw	$s3, 28($sp)
	sw	$s4, 32($sp)
	sw	$s5, 36($sp)
	sw	$s6, 40($sp)
	sw	$s7, 44($sp)

	lw	$t0, 0($a0)			# load word into x
	la	$s0, 4($sp)			# & cmp_w[0]
	lb	$t1, 0($s0)			# cmp_w[0]
	move	$t1, $t0			# cmp_w[0] = x
	lb	$t2, 4($s0)			# cmp_w[1]
	lb	$t3, 8($s0)			# cmp_w[2]
	lb	$t4, 16($s0)			# cmp_w[3]
	and	$t2, $t1, 0x00ffffff		# cmp_w[1]
	and	$t3, $t1, 0x0000ffff		# cmp_w[2]
	and	$t4, $t1, 0x000000ff		# cmp_w[3]
	sw	$t2, 8($sp)
	sw	$t3, 12($sp)
	sw	$t4, 16($sp)

	li	$s1, 0				# i = 0
	li	$s2, 0				# j = 0
	li	$s4, 0				# k = 0 

hsf_for:
	lw	$t5, num_rows			
	lw	$t6, num_columns
	
	bge	$s1, $t5, hsf_exit		# i < num_rows
	mul	$t7, $s1, $t6			# i * num_columns
	lw	$t8, puzzle			# & puzzle	
	add	$s6, $t7, $t8			# & puzzle + i * num_columns
	li	$t7, 4				# 4
	div	$t6, $t7			# num_columns / 4
	mflo	$s7

hsf_for2:
	lw	$t6, num_columns
	bge 	$s2, $s7, hsf_ipp		# goes to i++
	mul	$t0, $s2, 4
	add	$s6, $s6, $t0			# &array[j]
	lw	$s3, 0($s6)			# cur_word = array[j]
	
	mul	$t8, $s2, 4			# j * 4
	mul	$a1, $s1, $t6			# i * num_columns
	add	$a1, $a1, $t8			# start
	
	add	$t8, $s1, 1			# i + 1
	mul	$t8, $t8, $t6			# (i + 1) * num_columns
	sub	$a2, $t8, 1			# end

hsf_for3:
	li	$t9, 4				# 4
	bge	$s4, $t9, hsf_jpp		# goes to j++
	
	mul	$t9, $s4, 4
	add	$t9, $s0, $t9			# &cmp_w[k]
	lw	$t9, 0($t9)			# cmp_w[k]


	bne	$s3, $t9, hsf_cur_word_8	# move cur_word by 8
	add	$a1, $a1, $s4			# start + k
	jal	horiz_strncmp
	move 	$s5, $v0
	beq	$s5, $0, hsf_cur_word_8		# move cur_word by 8
	move	$v0, $s5 			# return ret($v0)
	j	hsf_exit

hsf_ipp:
	add	$s1, $s1, 1			# i++
	li	$s2, 0				# set j back to 0
	j	hsf_for				# goes back to the first for loop

hsf_jpp:
	add	$s2, $s2, 1			# j++
	li	$s4, 0				# set k back to 0
	j	hsf_for2			# goes back to the second for loop

hsf_cur_word_8:
	srl	$s3, $s3, 8			# cur_word >>= 8
	add	$s4, $s4, 1			# k++
	j	hsf_for3

hsf_exit:
	lw	$ra, 0($sp)
	lw	$s0, 4($sp)
	lw	$s1, 20($sp)
	lw	$s2, 24($sp)
	lw	$s3, 28($sp)
	lw	$s4, 32($sp)
	lw	$s5, 36($sp)
	lw	$s6, 40($sp)
	lw	$s6, 44($sp)
	add	$sp, $sp, 48
	jr	$ra
