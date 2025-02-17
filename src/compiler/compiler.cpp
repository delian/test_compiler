#include "compiler.h"

void Compiler::compile(AST *node)
{
    if (node == NULL)
    {
        return;
    }

    switch (node->type)
    {
        default:
            printf("Unknown node type\n");
            break;
    }
}


