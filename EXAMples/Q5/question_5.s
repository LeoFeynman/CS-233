# run with QtSpim -file main.s question_5.s

# struct node_t {
#     node_t *left;
#     node_t *right;
#     int *data;
# };
# int total_tree(node_t *root) {
#     if (root == NULL) {
#         return 0;
#     }
# 
#     int total = 0;
#     if (root->data != NULL) {
#         total += *(root->data);
#     }
# 
#     total += total_tree(root->left);
#     total += total_tree(root->right);
# 
#     return total;
# }
.globl total_tree
total_tree:
