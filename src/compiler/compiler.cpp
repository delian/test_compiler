#include "compiler.h"

using namespace std;

/*
Compiler::Compiler(string module_name) : Module(std::make_unique<llvm::Module>(module_name, Context)), Builder(Context)
{
    this->Name = module_name; // TODO: check later if I want to keep it at all
    // TODO: Init LLVM
}

Compiler::~Compiler()
{
}

void *Compiler::compile(AST *node) // The return format have to be changed
{
    if (node == NULL)
    {
        return;
    }

    switch (node->type)
    {
    case AST_TYPE::AST_PROGRAM_BLOCK:
        return compile(node->children[0]);
    case AST_TYPE::AST_FUNCTION_DECLARATION_NOPARM:
    {
        llvm::Type *ResultType = compile(node->children[0]); // Compile the resuylt type
        llvm::FunctionType *fnType = llvm::FunctionType::get(ResultType, false);
        llvm::Function *fn = llvm::Function::Create(fnType, llvm::Function::ExternalLinkage, (const char *)node->value, Module.get());
        BB = llvm::BasicBlock::Create(Context, (const char *)node->value, fn);
    }
    }
}

*/