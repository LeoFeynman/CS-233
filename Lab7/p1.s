.text

## char
## get_character(int i, int j) {
##     return puzzle[i * num_columns + j];
## }

.globl get_character
get_character:
	lw 	$t0, puzzle		# &puzzle
	lw	$t1, num_columns	# t1 = num_columns
	mul	$t2, $a0, $t1		# i * num_columns
	add	$t2, $t2, $a1		# i * num_columns + j
	add	$t3, $t0, $t2		# &puzzle[t2]
	lb	$t4, 0($t3)		# puzzle[t2]
	move	$v0, $t4 
	jr	$ra


## int
## horiz_strncmp(const char* word, int start, int end) {
##     int word_iter = 0;
## 
##     while (start <= end) {
##         if (puzzle[start] != word[word_iter]) {
##             return 0;
##         }
## 
##         if (word[word_iter + 1] == '\0') {
##             return start;
##         }
## 
##         start++;
##         word_iter++;
##     }
##     
##     return 0;
## }

.globl horiz_strncmp
horiz_strncmp:
	li 	$t0, 0			# word_iter = 0
	lw	$t5, puzzle		# &puzzle

while_loop:
	bgt	$a1, $a2, hs_exit	# while loop
	add	$t6, $t5, $a1		# &puzzle[start]
	lb	$t3, 0($t6)		# puzzle[start]
	add	$t8, $a0, $t0		# &word[wi]
	lb	$t4, 0($t8)		# word[wi]
	beq	$t3, $t4, hs_next	# second if loop
	li	$v0, 0			# return 0
	jr	$ra

hs_next:
	add	$t1, $t0, 1		# word_iter + 1
	add	$t2, $a0, $t1		# &word[wi+1]
	lb	$t7, 0($t2)		# word[wi+1]
	bne	$t7, 0, hs_plus		# start++ and wi++
	move	$v0, $a1		# return start
	jr	$ra

hs_plus:
	add	$a1, $a1, 1		# start++
	add	$t0, $t0, 1		# wi++
	j	while_loop

hs_exit:
	li	$v0, 0			# return 0
	jr	$ra
