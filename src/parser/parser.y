%{
    #include <stdio.h>
    #include <ast.h>
    
    extern int yylex();
    extern int yyparse();
    void yyerror(char *s);
%}

%union {
    int ival;
    float fval;
    char *sval;
    struct AST *ast;
}

%token <fval> FLOAT
%token <ival> INTEGER
%token <sval> NAME
%token <sval> STRING
%token SEMICOLON
%token COMMA
%token INCLUDE LPAREN RPAREN RETURN CONTINUE BREAK WHILE FOR IF 
%token T_VOID T_INT T_FLOAT T_BOOL T_STRING 
%token DECLARE TRUE FALSE
%token PLUS MINUS TIMES DIVIDE MODULO EQ AND OR XOR NOT TILDE
%token RBRACE LBRACE
%token LBRACKET RBRACKET DOLLAR EQUAL CARET ELSE NE LT LE GT GE

%start program

%type <ast> program_block program
%type <ast> type_spec variable_declaration variable_assignment parameter_exp
%type <ast> parameters_exp function_call variable factor_val factor term_modulo term_times term_divide term
%type <ast> expression_term_minus expression_term_plus expression
%type <ast> bool_expression bool_term bool_factor bool_true bool_false bool_term_not bool_term_tilde
%type <ast> bool_exp_and bool_exp_or bool_exp_xor
%type <ast> while_statement block break_statement continue_statement return_statement
%type <ast> if_statement for_statement statement statements parameter parameters
%type <ast> function_declaration declare_function glob_variable

%%

program: program_block {
    ast = $1;
};

program_block: program_block glob_variable { $$ = $1; ast_add($$, 1, $2); }
             | glob_variable { $$ = ast_new_add(AST_PROGRAM_BLOCK, 1, $1); }
             | program_block function_declaration { $$ = $1; ast_add($$, 1, $2); }
             | function_declaration { $$ = ast_new_add(AST_PROGRAM_BLOCK, 1, $1); }
             | program_block SEMICOLON { $$ = $1; }
             | SEMICOLON {} // Empty statement
             | program_block declare_function { $$ = $1; ast_add($$, 1, $2); }
             | declare_function { $$ = ast_new_add(AST_PROGRAM_BLOCK, 1, $1); };

glob_variable: variable_declaration SEMICOLON { $$ = ast_new_add(AST_GLOB_VARIABLE, 1, $1); };

declare_function: DECLARE type_spec NAME LPAREN parameters RPAREN { $$ = ast_new_add(AST_DECLARE_FUNCTION, 2, $2, $5); $$->value = $3; value_str($$, "%s", $3); }
                | DECLARE type_spec NAME LPAREN RPAREN { $$ = ast_new_add(AST_DECLARE_FUNCTION_NOPARM, 1, $2); $$->value = $3; value_str($$, "%s", $3); };

function_declaration: type_spec NAME LPAREN parameters RPAREN block { $$ = ast_new_add(AST_FUNCTION_DECLARATION, 3, $1, $4, $6); $$->value = $2; value_str($$, "%s", $2); }
                    | type_spec NAME LPAREN RPAREN block { $$ = ast_new_add(AST_FUNCTION_DECLARATION_NOPARM, 2, $1, $5); $$->value = $2; value_str($$, "%s", $2); };

parameters: parameters COMMA parameter { $$ = $1; ast_add($$, 1, $3); }
          | parameter { $$ = ast_new_add(AST_PARAMETERS, 1, $1); };

parameter: type_spec NAME { $$ = ast_new_add(AST_PARAMETER, 1, $1); $$->value = $2; value_str($$, "%s", $2); };

block: statement { $$ = ast_new_add(AST_BLOCK_STATEMENT, 1, $1); }
     | LBRACE statements RBRACE { $$ = ast_new_add(AST_BLOCK_STATEMENTS, 1, $2); }
     | LBRACE RBRACE { $$ = ast_new(AST_BLOCK_EMPTY); };

statements: statement { $$ = ast_new_add(AST_STATEMENTS, 1, $1); }
          | statements SEMICOLON statement { $$ = $1; ast_add($$, 1, $3); };

statement: bool_expression { $$ = ast_new_add(AST_STATEMENT, 1, $1); }
         | variable_declaration { $$ = ast_new_add(AST_STATEMENT, 1, $1); }
         | return_statement { $$ = ast_new_add(AST_STATEMENT, 1, $1); }
         | continue_statement { $$ = ast_new_add(AST_STATEMENT, 1, $1); }
         | break_statement { $$ = ast_new_add(AST_STATEMENT, 1, $1); }
         | while_statement { $$ = ast_new_add(AST_STATEMENT, 1, $1); }
         | for_statement { $$ = ast_new_add(AST_STATEMENT, 1, $1); }
         | variable_assignment { $$ = ast_new_add(AST_STATEMENT, 1, $1); }
         | if_statement { $$ = ast_new_add(AST_STATEMENT, 1, $1); };

if_statement: IF LPAREN bool_expression RPAREN block { $$ = ast_new_add(AST_IF_STATEMENT, 2, $3, $5); };

for_statement: FOR LPAREN statement SEMICOLON statement SEMICOLON statement RPAREN block { $$ = ast_new_add(AST_FOR_STATEMENT_3, 4, $3, $5, $7, $9); }
             | FOR LPAREN RPAREN block { $$ = ast_new_add(AST_FOR_STATEMENT_0, 1, $4); }
             | FOR LPAREN statement RPAREN block { $$ = ast_new_add(AST_FOR_STATEMENT_1, 2, $3, $5); }
             | FOR LPAREN statement SEMICOLON statement RPAREN block { $$ = ast_new_add(AST_FOR_STATEMENT_2, 3, $3, $5, $7); };

return_statement: RETURN expression { $$ = ast_new_add(AST_RETURN_STATEMENT_EXPRESSION, 1, $2); }
                | RETURN { $$ = ast_new(AST_RETURN_STATEMENT); };

continue_statement: CONTINUE { $$ = ast_new(AST_CONTINUE_STATEMENT); }
                  | CONTINUE expression { $$ = ast_new_add(AST_CONTINUE_STATEMENT_EXPRESSION, 1, $2); };

break_statement: BREAK { $$ = ast_new(AST_BREAK_STATEMENT); }
               | BREAK expression { $$ = ast_new_add(AST_BREAK_STATEMENT_EXPRESSION, 1, $2); };

while_statement: WHILE LPAREN bool_expression RPAREN block { $$ = ast_new_add(AST_WHILE_STATEMENT, 2, $3, $5); };

bool_expression: bool_exp_xor { $$ = ast_new_add(AST_BOOL_EXPRESSION, 1, $1); }
               | bool_exp_or { $$ = ast_new_add(AST_BOOL_EXPRESSION, 1, $1); }
               | bool_exp_and { $$ = ast_new_add(AST_BOOL_EXPRESSION, 1, $1); }
               | bool_term { $$ = ast_new_add(AST_BOOL_EXPRESSION, 1, $1); };

bool_exp_xor: bool_expression XOR bool_term { $$ = ast_new_add(AST_BOOL_EXP_XOR, 2, $1, $3); };
bool_exp_or: bool_expression OR bool_term { $$ = ast_new_add(AST_BOOL_EXP_OR, 2, $1, $3); };
bool_exp_and: bool_expression AND bool_term { $$ = ast_new_add(AST_BOOL_EXP_AND, 2, $1, $3); };

bool_term: bool_factor { $$ = ast_new_add(AST_BOOL_TERM, 1, $1); }
         | bool_term_tilde { $$ = ast_new_add(AST_BOOL_TERM, 1, $1); }
         | bool_term_not { $$ = ast_new_add(AST_BOOL_TERM, 1, $1); };

bool_term_not: NOT bool_factor { $$ = ast_new_add(AST_BOOL_TERM_NOT, 1, $2); };
bool_term_tilde: TILDE bool_factor { $$ = ast_new_add(AST_BOOL_TERM_TILDE, 1, $2); };

bool_factor: bool_true { $$ = ast_new_add(AST_BOOL_FACTOR, 1, $1); }
           | bool_false { $$ = ast_new_add(AST_BOOL_FACTOR, 1, $1); }
           | expression { $$ = ast_new_add(AST_BOOL_FACTOR, 1, $1); };


bool_true: TRUE { $$ = ast_new(AST_BOOL_TRUE); $$->value = &(int){1}; value_str($$,"true (1)"); };
bool_false: FALSE { $$ = ast_new(AST_BOOL_FALSE); $$->value = &(int){0}; value_str($$,"false (0)"); };

expression: expression_term_plus { $$ = ast_new_add(AST_EXPRESSION, 1, $1); }
          | expression_term_minus { $$ = ast_new_add(AST_EXPRESSION, 1, $1); }
          | term { $$ = ast_new_add(AST_EXPRESSION, 1, $1); };

expression_term_plus: expression PLUS term { $$ = ast_new_add(AST_EXPRESSION_TERM_PLUS, 2, $1, $3); };
expression_term_minus: expression MINUS term { $$ = ast_new_add(AST_EXPRESSION_TERM_MINUS, 2, $1, $3); };

term: term_times { $$ = ast_new_add(AST_TERM, 1, $1); }
    | term_divide { $$ = ast_new_add(AST_TERM, 1, $1); }
    | term_modulo { $$ = ast_new_add(AST_TERM, 1, $1); }
    | factor { $$ = ast_new_add(AST_TERM, 1, $1); };

term_times: term TIMES factor { $$ = ast_new_add(AST_TERM_TIMES, 2, $1, $3); }; 
term_divide: term DIVIDE factor { $$ = ast_new_add(AST_TERM_DIVIDE, 2, $1, $3); };
term_modulo: term MODULO factor { $$ = ast_new_add(AST_TERM_MODULO, 2, $1, $3); };

factor: LPAREN expression RPAREN { $$ = ast_new_add(AST_FACTOR, 1, $2); }
      | factor_val { $$ = ast_new_add(AST_FACTOR, 1, $1); }
      | variable { $$ = ast_new_add(AST_FACTOR, 1, $1); }
      | function_call { $$ = ast_new_add(AST_FACTOR, 1, $1); };

factor_val: INTEGER { $$ = ast_new(AST_FACTOR_VAL); $$->value = &(int){$1}; value_str($$, "%d", $1); } // Annonymous re-allocation of a value
      | MINUS INTEGER { $$ = ast_new(AST_FACTOR_VAL_NEG); $$->value = &(int){$2}; value_str($$, "%d", $2); }
      | FLOAT { $$ = ast_new(AST_FACTOR_VAL); $$->value = &(float){$1}; value_str($$, "%f", $1); }
      | MINUS FLOAT { $$ = ast_new(AST_FACTOR_VAL_NEG); $$->value = &(float){$2}; value_str($$, "%f", $2); };
      | STRING { $$ = ast_new(AST_FACTOR_VAL); $$->value = $1; value_str($$, "%s", $1); }

variable: NAME { $$ = ast_new(AST_VARIABLE); $$->value = $1; value_str($$, "%s", $1); };

function_call: NAME LPAREN parameters_exp RPAREN { $$ = ast_new_add(AST_FUNCTION_CALL, 1, $3); $$->value = $1; value_str($$, "%s", $1); }
             | NAME LPAREN RPAREN { $$ = ast_new(AST_FUNCTION_CALL); $$->value = $1; value_str($$, "%s", $1); };

parameters_exp: parameters_exp COMMA parameter_exp { $$ = $1; ast_add($$, 1, $3); }
              | parameter_exp { $$ = ast_new_add(AST_PARAMETERS_EXP, 1, $1); };

parameter_exp: expression { $$ = ast_new_add(AST_PARAMETER_EXP, 1, $1); };

variable_assignment: NAME EQ expression { $$ = ast_new_add(AST_VARIABLE_ASSIGNMENT, 1, $3); $$->value = $1; value_str($$, "%s", $1); };

variable_declaration: type_spec NAME EQ expression { $$ = ast_new_add(AST_VARIABLE_DECLARATION, 1, $4); $$->value = $2; value_str($$, "%s", $2); }
                    | type_spec NAME { $$ = ast_new(AST_VARIABLE_DECLARATION); $$->value = $2; value_str($$, "%s", $2); };

type_spec: T_VOID { $$ = ast_new(AST_T_VOID); }
         | T_INT { $$ = ast_new(AST_T_INT); }
         | T_FLOAT { $$ = ast_new(AST_T_FLOAT); }
         | T_BOOL { $$ = ast_new(AST_T_BOOL); }
         | T_STRING { $$ = ast_new(AST_T_STRING); };

%%

#include <readline/readline.h>
#include <readline/history.h>

#define HISTORYFILE ".ply_history"

AST *ast;

typedef struct yy_buffer_state * YY_BUFFER_STATE;
extern int yyparse();
extern YY_BUFFER_STATE yy_scan_string(char * str);
extern void yypush_buffer_state(YY_BUFFER_STATE new_buffer);
extern void yy_delete_buffer(YY_BUFFER_STATE buffer);

static char *line_read = (char *)NULL;

void yyerror ( char *s ) {
    printf("ERROR: %s\n", s);
}

extern FILE *yyin;

int parse_file(char *filename) {
    FILE *file = fopen(filename, "r");
    if (!file) {
        printf("Error: Could not open file '%s'\n", filename);
        return 1;
    }
    yyin = file;
    int parse_err = yyparse();
    fclose(file);
    return parse_err;
}


int pmain() {

    read_history(HISTORYFILE);
    while(1) {
        line_read = readline("Parser> ");
        if ((!line_read)||(!*line_read)) break;
        add_history(line_read);
        write_history(HISTORYFILE);

        printf("line_read: '%s'\n", line_read);

        YY_BUFFER_STATE buffer = yy_scan_string(line_read);
        yypush_buffer_state(buffer);
        int parse_err = yyparse();
        yy_delete_buffer(buffer);

        printf("\n");
        if (parse_err) {
            printf("Parse error\n");
        } else {
            ast_print(ast);
            ast_free(ast); // Auto free of the AST shall be implemented
        }
        ast = NULL;
    }
    return 0;
}
