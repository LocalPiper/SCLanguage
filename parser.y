%{
#include <iostream>
using namespace std;

int yylex();

void yyerror(const char* s) {
  cerr << "Error: " << s << endl;
}

extern char* yytext;
%}

%token NUMBER PLUS MINUS EOL

%%

program:
    program statement {}
    |
    ;

statement:
    expression EOL { cout << "Result: " << $1 << endl; }
    ;

expression:
    expression PLUS term { $$ = $1 + $3; }
    | expression MINUS term { $$ = $1 - $3; }
    | term { $$ = $1; }
    ;

term:
    NUMBER { $$ = atoi(yytext); }
    ;

%%

int main() {
    yyparse();
    return 0;
}

