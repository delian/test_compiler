#include <stdlib.h>

typedef struct AST AST;

struct AST {
    char *type;
    char *value;

    int len;  // I am not sure I want this. Keep it just in case
    AST *children[10];
};

extern AST *ast;

// int ast_add_child(AST *parent, AST *child) {
//     for (int i = 0; i < 10; i++) {
//         if (parent->children[i] == NULL) {
//             parent->children[i] = child;
//             return 0;
//         }
//     }
//     return 1;
// }

AST *ast_new(char *type) {
    AST *node = malloc(sizeof(AST));
    node->type = type;
    return node;
}
