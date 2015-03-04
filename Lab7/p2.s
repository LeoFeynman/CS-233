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
	li	$t0, 0			# wi = 0
	move	$t1, $a1		# i = start_i
	lw	$t9, num_rows		# load num_rows
	bge	$t1, $t9, vs_exit	# i < num_rows


	move	$a0, $t1		# argument i in get_char
	move	$a1, $a2		# argument j in get_char 
	jal	get_character

	move	$t4, $v0		# t4 = get_char
	add	$t2, $a0, $t0		# &word[wi]
	lb	$t3, 0($t2)		# word[wi]
	beq	$t4, $t3, vs_next	# first if loop
	li	$v0, 0			# return 0

vs_next:
	add	$t5, $t0, 1		# word_iter + 1
	add	$t6, $a0, $t5		# &word[wi+1]
	lb	$t7, 0($t6)		# word[wi+1]
	bne	$t7, 0, vs_exit		# second if loop
	lw	$t8, num_columns	# load num_columns
	mul	$t8, $t8, $t1		# i * num_columns
	add	$t8, $t8, $a2		# i * num_columns + j
	move	$v0, $t8		# return t8
	jr	$ra

vs_exit:
	li	$v0, 0			# return 0 
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
	jr	$ra
