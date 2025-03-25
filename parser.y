%{
#include <iostream>
using namespace std;

int yylex();

void yyerror(const char* s) {
  cerr << "Error: " << s << endl;
}

extern char* yytext;
%}

%token NUMBER PLUS MINUS STAR SLASH EOL

%%

statements:
          | statements expression EOL { cout << "= " << $2 << endl; }
          ;

expression:
    expression PLUS factor { $$ = $1 + $3; }
    | expression MINUS factor { $$ = $1 - $3; }
    | factor { $$ = $1; }
    ;

factor:
    factor STAR term { $$ = $1 * $3; }
    | factor SLASH term { $$ = $1 / $3; }
    | term { $$ = $1; }
    ;

term:
      NUMBER { $$ = atoi(yytext); }
%%

int main() {
    yyparse();
    return 0;
}

