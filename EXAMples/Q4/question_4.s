# run with QtSpim -file main.s question_4.s

# struct node_t {
#     node_t *next;
#     int *data;
# };
# void increment_linked(node_t *head, int value) {
#     for (node_t *curr = head; curr != NULL; curr = curr->next) {
#         *(curr->data) += value;
#     }
# }
.globl increment_linked
increment_linked:
