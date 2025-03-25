%{
#include "parser.tab.hpp"
%}

%%

[0-9]+      { yylval.num = atoi(yytext); return NUMBER; }
"+"         { return PLUS; }
"-"         { return MINUS; }
"*"         { return STAR; }
"/"         { return SLASH; }
"("         { return OP; }
")"         { return CP; }
\n          { return EOL; }
[ \t]       {}
"Sayeth"    { return PRINT; }
"ShallBe"   { return ASSIGN; }
[a-zA-Z_][a-zA-Z_0-9]* { yylval.str = strdup(yytext); return IDENTIFIER; }
.           { return 0; }
%%

int yywrap() {
    return 1;
}

