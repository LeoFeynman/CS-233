# run with QtSpim -file main.s question_4.s

# int find_minimum_index(int *array, int length) {
#     int min = array[0];
#     int min_index = 0;
# 
#     for (int i = 1; i < length; i++) {
#         if (array[i] < min) {
#             min = array[i];
#             min_index = i;
#         }
#     }
# 
#     return min_index;
# }
.globl find_minimum_index
find_minimum_index:
	lw	$t0, 0($a0)	# min
	li	$t1, 0		# min_index
	li	$t2, 1		# i = 1
	
loop:
	bge	$t2, $a1, loop_done
	mul	$t3, $t2, 4
	add	$t3, $a0, $t3	# &array[i]
	lw	$t3, 0($t3)	# array[i]

loop2:
	bge	$t3, $t0, loop2_done
	move	$t0, $t3	# min = array[i]
	move	$t1, $t2	# min_index = i
	j	loop2

loop2_done:
	add	$t2, $t2, 1	# i++
	j	loop

loop_done:
	move	$v0, $t1
	j	$ra
