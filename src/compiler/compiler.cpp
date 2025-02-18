#include "compiler.h"

using namespace std;

Compiler::Compiler(string module_name) : Module(std::make_unique<llvm::Module>(module_name, Context)), Builder(Context)
{
    this->Name = module_name; // TODO: check later if I need to keep it at all
}

void Compiler::compile(AST *node)
{
    if (node == NULL)
    {
        return;
    }

    switch (node->type)
    {
    }
}
