#include "ast.h"
#include <stdio.h>
#include <stdarg.h>

AST *ast_new(char *type, AST_TYPE type_enum)
{
    AST *node = malloc(sizeof(AST));
    node->child = NULL;
    node->type = type;
    node->type_enum = type_enum;
    node->len = 0;
    node->value = NULL;
    node->value_str = NULL;
    return node;
}

void ast_add(AST *node, int n, ...)
{
    va_list args;

    node->child = realloc(node->child, (node->len + n) * sizeof(AST *));
    int total = node->len + n;

    for (va_start(args, n); node->len < total; node->len++)
    {
        AST *child = va_arg(args, AST *);
        if (child == NULL)
            continue;
        // printf("node %s childlen %d < %d\n", node->type, node->len, total);
        node->child[node->len] = child;
    }

    va_end(args);
}

AST *ast_new_add(char *type, AST_TYPE type_enum, int n, ...)
{
    AST *node = ast_new(type, type_enum);
    va_list args;

    node->child = realloc(node->child, (node->len + n) * sizeof(AST *));
    int total = node->len + n;

    for (va_start(args, n); node->len < total; node->len++)
    {
        AST *child = va_arg(args, AST *);
        if (child == NULL)
            continue;
        node->child[node->len] = child;
    }

    va_end(args);

    return node;
}

void ast_free(AST *node)
{
    for (int i = 0; i < node->len; i++)
    {
        ast_free(node->child[i]);
    }
    free(node->value_str); // Explicit malloc needs to be freed. I won't do this for ->value as it often points to ELF allocated static symbols in memory which are shared constants and not allocated with malloc
    free(node->child);
    free(node);
}

void ast_print_depth(AST *node, int depth)
{
    for (int i = 0; i < depth; i++)
        printf("|  ");
    printf("Type: '%s' Value: '%s'", node->type, node->value_str);
    if (node->len > 0)
        printf(" Children (%d):", node->len);
    printf("\n");
    for (int i = 0; i < node->len; i++)
        ast_print_depth(node->child[i], depth + 1);
}

void ast_print(AST *node)
{
    ast_print_depth(node, 0);
}
