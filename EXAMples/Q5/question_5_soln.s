# run with QtSpim -file main.s question_5_soln.s

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
    bne     $a0, $0, tt_go      # root == NULL
    move    $v0, $0             # return 0
    jr      $ra
tt_go:
    sub     $sp, $sp, 12
    sw      $ra, 0($sp)
    sw      $s0, 4($sp)
    sw      $s1, 8($sp)
    move    $s0, $a0

    move    $s1, $0             # int total = 0
    lw      $t0, 8($s0)         # root->data
    beq     $t0, $0, tt_rec     # root->data != NULL
    lw      $s1, 0($t0)         # total += *(root->data)

tt_rec:
    lw      $a0, 0($s0)         # root->left
    jal     total_tree          # total_tree(root->left)
    add     $s1, $s1, $v0       # total += total_tree(root->left)

    lw      $a0, 4($s0)         # root->right
    jal     total_tree          # total_tree(root->right)
    add     $v0, $s1, $v0       # total += total_tree(root->right)

    lw      $ra, 0($sp)
    lw      $s0, 4($sp)
    lw      $s1, 8($sp)
    add     $sp, $sp, 12
    jr      $ra                 # return total
