# run with QtSpim -file main.s question_5.s

# struct node_t {
#     node_t *next;
#     node_t *prev;
#     int data;
# };
# void remove_value(node_t *head, int value) {
#     node_t *curr = head;
#     while (curr != NULL) {
#         node_t *temp = curr->next;
#         if (curr->data == value) {
#             if (curr->prev != NULL) {
#                 curr->prev->next = temp;
#             }
#             if (temp != NULL) {
#                 temp->prev = curr->prev;
#             }
#             free(curr);  // CALL THIS FUNCTION - DO NOT INLINE! (jal free)
#         }
#         curr = temp;
#     }
# }
.globl remove_value
remove_value:
	sub	$sp, $sp, 12
	sw	$ra, 0($sp)
	sw	$s0, 4($sp)	
	sw	$s1, 8($sp)	
	move	$s0, $a0	# curr = head

while_loop:
	beq	$s0, $0, loop_done
	lw	$s1, 0($s0)	# temp = curr->next
if_loop:
	lw	$t2, 8($s0)	# curr->data
	bne	$t2, $a1, if_done
	lw	$t3, 4($s0)	# curr->prev
	beq	$t3, $0, if2
	sw	$s1, 0($t3)
if2:
	beq	$s1, $0, free_call
	sw	$t3, 4($s1)	# temp->prev = curr->prev
free_call:
	move	$a0, $s0
	jal	free
if_done:
	move	$s0, $s1
	j	while_loop
loop_done:	
	lw	$ra, 0($sp)
	lw	$s0, 4($sp)
	lw	$s1, 8($sp)
	add	$sp, $sp, 12 
	j	$ra
