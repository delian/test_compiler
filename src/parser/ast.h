#ifndef AST_H
#define AST_H

#define __GNU_SOURCE
#include <stdio.h>
#include <stdlib.h>

typedef struct AST AST;

struct AST
{
    char *type;
    void *value;
    char *value_str;
    int len;
    AST **child;
};

extern AST *ast;
extern AST *ast_new(char *type);
extern AST *ast_new_add(char *type, int n, ...);
extern void ast_add(AST *node, int n, ...);
extern void ast_print(AST *node);
extern void ast_free(AST *node);
extern char *ssprintf(const char *format, ...);

#define value_str(node, ...) (node->value_str = ssprintf(__VA_ARGS__))

#endif
