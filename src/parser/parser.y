%{
    #include "../lexer.tab.h"
%}

%%

input: /* empty */
    | input line
    ;

line: '\n'