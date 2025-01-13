%option noyywrap

%{
    #include "lexer.tab.h"
%}

DIGIT [0-9]

%%
[ \t\n]                  ;
{DIGIT}+                 { yylval = atoi(yytext); return INTEGER; }
{DIGIT}+"."{DIGIT}*      { yylval = atof(yytext); return FLOAT; }
"+"                      { return PLUS; }
"-"                      { return MINUS; }
"*"                      { return TIMES; }
"/"                      { return DIVIDE; }
"("                      { return LP; }
")"                      { return RP; }
"="                      { return EQ; }

%%
