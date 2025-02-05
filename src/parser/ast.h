#ifndef AST_H
#define AST_H

#include <stdlib.h>

typedef struct AST AST;

struct AST
{
    char *type;
    void *value;

    int len; // I am not sure I want this. Keep it just in case
    AST *children[10];
};

extern AST *ast;
extern AST *ast_new(char *type);

extern void ast_print(AST *node);

#endif
