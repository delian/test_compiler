#ifndef __COMPILER_H__
#define __COMPILER_H__

#include "ast.h"
#include <string>

#include <llvm/IR/LLVMContext.h>
#include <llvm/IR/Module.h>
#include <llvm/IR/IRBuilder.h>
#include <llvm/IR/Verifier.h>

using namespace std;

class Compiler
{
private:
    string Name;

    llvm::LLVMContext Context;
    std::unique_ptr<llvm::Module> Module;
    llvm::IRBuilder<> Builder;

public:
    Compiler(string module_name);
    void compile(AST *node);
};

#endif
