%{
#include "parser.tab.hpp"
%}

%%

[0-9]+      { return NUMBER; }
"+"         { return PLUS; }
"-"         { return MINUS; }
[ \t\r]     {}
"\n"        { return EOL; }

%%

int yywrap() {
    return 1;
}

