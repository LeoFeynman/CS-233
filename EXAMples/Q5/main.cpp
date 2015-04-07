// compile with g++ -Wall -O0 main.cpp -o total_tree
// and run with ./total_tree

#include <cstdlib>
#include <stdio.h>

struct node_t {
    node_t *left;
    node_t *right;
    int *data;
};
node_t *create_int_ptr_binary_tree(int seed, int depth) {
    if (depth == 0) {
        return NULL;
    }
    srand(seed);

    node_t *root = new node_t;
    int null_data = rand() % 5;
    if (null_data == 0) {
        root->data = NULL;
    } else {
        root->data = new int;
        *(root->data) = rand() % 100;
    }

    int delta = rand() % 100;
    
    root->left = create_int_ptr_binary_tree(seed + delta, depth - 1);
    root->right = create_int_ptr_binary_tree(seed - delta, depth - 1);

    return root;
}


int total_tree(node_t *root) {
    if (root == NULL) {
        return 0;
    }

    int total = 0;
    if (root->data != NULL) {
        total += *(root->data);
    }

    total += total_tree(root->left);
    total += total_tree(root->right);

    return total;
}
int main() {
    node_t *test0 = create_int_ptr_binary_tree(544, 3);
    printf("%d \n", total_tree(test0));
    node_t *test1 = create_int_ptr_binary_tree(778, 4);
    printf("%d \n", total_tree(test1));
    return 0;
}