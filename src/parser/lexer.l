%option noyywrap nodefault debug stack

%x COMMENT
%x INCLUDE

%{
#include <stdio.h>
#include "../temp/bison_parser.h"

#define MAX_INCLUDE_DEPTH 10
YY_BUFFER_STATE include_stack[MAX_INCLUDE_DEPTH];
int include_stack_top = 0;
%}


%%

[ \t\n]                     ;
\/\*                        BEGIN(COMMENT); // Change a state and ignore multiline comments
<COMMENT>{
    [^*\n]*                 ;
    \n                      ;
    \*+[^*/\n]*             ;
    \*+\/                   BEGIN(INITIAL);
}
#.*                         ; // Ignore a comment in a single line
[0-9]+\.[0-9]*              { yylval.fval = atof(yytext); return FLOAT; }
[0-9]+                      { yylval.ival = atoi(yytext); return INTEGER; }
"+"                         { return PLUS; }
"-"                         { return MINUS; }
"*"                         { return TIMES; }
"/"                         { return DIVIDE; }
"("                         { return LPAREN; }
")"                         { return RPAREN; }
"{"                         { return LBRACE; }
"}"                         { return RBRACE; }
"["                         { return LBRACKET; }
"]"                         { return RBRACKET; }
\$                          { return DOLLAR; }
";"                         { return SEMICOLON; }
","                         { return COMMA; }
"^"                         { return CARET; }
\~                          { return TILDE; }
"%"                         { return MODULO; }
"=="                        { return EQUAL; }
"="                         { return EQ; }
"!="                        { return NE; }
"<"                         { return LT; }
"<="                        { return LE; }
">"                         { return GT; }
">="                        { return GE; }
"&&"                        { return AND; }
"||"                        { return OR; }
"!"                         { return NOT; }
if                          { return IF; }
else                        { return ELSE; }
while                       { return WHILE; }
for                         { return FOR; }
return                      { return RETURN; }
continue                    { return CONTINUE; }
break                       { return BREAK; }
and                         { return AND; }
or                          { return OR; }
xor                         { return XOR; }
not                         { return NOT; }
true                        { return TRUE; }
false                       { return FALSE; }
void                        { return T_VOID; }
int                         { return T_INT; }
float                       { return T_FLOAT; }
bool                        { return T_BOOL; }
string                      { return T_STRING; }
declare                     { return DECLARE; }
include                     { BEGIN(INCLUDE); }
<INCLUDE>{
    [ \t]                   ;
    [a-zA-Z0-9_\/\.]+       { 
                                if (include_stack_top >= MAX_INCLUDE_DEPTH) {
                                    fprintf(stderr, "Include depth is too deep\n");
                                    yyterminate();
                                }
                                include_stack[include_stack_top++] = YY_CURRENT_BUFFER;
                                yyin = fopen(yytext, "r");
                                if (!yyin) {
                                    fprintf(stderr, "Cannot open include file: %s\n", yytext);
                                    yyterminate();
                                }
                                yy_switch_to_buffer(yy_create_buffer( yyin, YY_BUF_SIZE));
                                BEGIN(INITIAL);
                            }
}


[a-zA-Z_\$][a-zA-Z0-9_\$]*  { yylval.sval = strdup(yytext); return NAME; }

.                           { 
                                fprintf(stderr, "Tokenizing error: '%c'\n", *yytext); 
                                yyterminate(); 
                            }
<<EOF>>                     {
                                if (include_stack_top > 0) {
                                    fclose(yyin);
                                    yy_delete_buffer(YY_CURRENT_BUFFER);
                                    yy_switch_to_buffer(include_stack[--include_stack_top]);
                                } else 
                                    yyterminate();
                            }

%%
