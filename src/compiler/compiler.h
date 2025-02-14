#ifndef __COMPILER_H__
#define __COMPILER_H__

#include <stdio.h>
#include "ast.h"

class Compiler
{
    public:
        void compile(AST *node);
};

#endif
