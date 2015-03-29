// compile with g++ -Wall -O0 main.cpp -o increment_linked
// and run with ./increment_linked

#include <cstdlib>
#include <stdio.h>

struct node_t {
    node_t *next;
    int *data;
};
node_t *create_int_ptr_linked_list(int seed, int length) {
    if (length == 0) {
        return NULL;
    }
    srand(seed);

    node_t *head = new node_t;
    head->data = new int;
    *(head->data) = rand() % 100;

    head->next = create_int_ptr_linked_list(seed + 1, length - 1);

    return head;
}
void print_int_ptr_linked_list(node_t *head) {
    if (head == NULL) {
        printf("(null) ");
    }

    while (head != NULL) {
        printf("%d ", *(head->data));
        head = head->next;
    }
    printf("\n");
}

void increment_linked(node_t *head, int value) {
    for (node_t *curr = head; curr != NULL; curr = curr->next) {
        *(curr->data) += value;
    }
}
int main() {
    node_t *test0 = create_int_ptr_linked_list(589, 3);
    increment_linked(test0, 3);
    print_int_ptr_linked_list(test0);
    node_t *test1 = create_int_ptr_linked_list(442, 6);
    increment_linked(test1, 5);
    print_int_ptr_linked_list(test1);
    return 0;
}