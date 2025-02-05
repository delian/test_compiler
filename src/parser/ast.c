#include "ast.h"
#include <stdio.h>

AST *ast_new(char *type)
{
    AST *node = malloc(sizeof(AST));
    node->type = type;
    node->len = 0;
    return node;
}

void ast_print_depth(AST *node, int depth)
{
    for (int i = 0; i < depth; i++)
        printf("|  ");
    printf("Type: '%s' Value: '%s'", node->type, (char *)node->value);
    if (node->len > 0)
        printf(" Children (%d):", node->len);
    printf("\n");
    for (int i = 0; i < node->len; i++)
    {
        ast_print_depth(node->children[i], depth + 1);
    }
}

void ast_print(AST *node)
{
    ast_print_depth(node, 0);
}