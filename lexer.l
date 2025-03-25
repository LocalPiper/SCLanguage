%{
#include "parser.tab.hpp"
%}

%%

[0-9]+      { return NUMBER; }
"+"         { return PLUS; }
"-"         { return MINUS; }
"*"         { return STAR; }
"/"         { return SLASH; }
"("         { return OP; }
")"         { return CP; }
\n          { return EOL; }
[ \t]       {}
.           { return 0; }
%%

int yywrap() {
    return 1;
}

