%option noyywrap nodefault debug

%{
#include "../lexer.tab.h"
#include "../temp/bison_parser.h"
%}


%%

[ \t\n]                  ;
#.*                      ; // Ignore a comment
[0-9]+                   { yylval = atoi(yytext); return INTEGER; }
[0-9]+\.[0-9]*           { yylval = atof(yytext); return FLOAT; }
"+"                      { return PLUS; }
"-"                      { return MINUS; }
"*"                      { return TIMES; }
"/"                      { return DIVIDE; }
"("                      { return LPAREN; }
")"                      { return RPAREN; }
"{"                      { return LBRACE; }
"}"                      { return RBRACE; }
"["                      { return LBRACKET; }
"]"                      { return RBRACKET; }
\$                       { return DOLLAR; }
";"                      { return SEMICOLON; }
","                      { return COMMA; }
"="                      { return EQUAL; }
"^"                      { return CARET; }
\~                       { return TILDE; }
"%"                      { return MODULO; }
"=="                     { return EQ; }
"!="                     { return NE; }
"<"                      { return LT; }
"<="                     { return LE; }
">"                      { return GT; }
">="                     { return GE; }
"&&"                     { return AND; }
"||"                     { return OR; }
"!"                      { return NOT; }
if                       { return IF; }
else                     { return ELSE; }
while                    { return WHILE; }
for                      { return FOR; }
return                   { return RETURN; }
continue                 { return CONTINUE; }
break                    { return BREAK; }
and                      { return AND; }
or                       { return OR; }
xor                      { return XOR; }
not                      { return NOT; }
true                     { return TRUE; }
false                    { return FALSE; }
void                     { return T_VOID; }
int                      { return T_INT; }
float                    { return T_FLOAT; }
bool                     { return T_BOOL; }
string                   { return T_STRING; }
declare                  { return DECLARE; }
include                  { return INCLUDE; }


.                        { fprintf(stderr, "Tokenizing error: '%c'\n", *yytext); yyterminate(); }

%%

int ymain() {
    printf("Lexer> ");
    yylex();
    return 0;
}
