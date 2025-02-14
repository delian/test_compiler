#include "compiler.h"

void Compiler::compile(AST *node)
{
    if (node == NULL)
    {
        return;
    }

    switch (node->type_enum)
    {
        default:
            printf("Unknown node type\n");
            break;
    }
}


