%{
#include <iostream>
#include <unordered_map>
using namespace std;

int yylex();

void yyerror(const char* s) {
  cerr << "Error: " << s << endl;
}

extern char* yytext;

unordered_map<string, int> variables;

%}
%union {
  int num;
  char* str;
}

%token <num> NUMBER
%token <str> IDENTIFIER
%token PLUS MINUS STAR SLASH OP CP EOL PRINT ASSIGN
%type <num> program statements statement expression factor term

%%

program:
       statements
       ;

statements:
          statements statement
          | statement
          ;

statement:
         PRINT expression EOL { cout << "Milord proclaimeth: " << $2 << "!" << endl; }
         | IDENTIFIER ASSIGN expression EOL { variables[$1] = $3; }
         | expression EOL { }

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
      | IDENTIFIER { $$ = variables[$1]; }
      | MINUS term { $$ = -$2; }
      | OP expression CP { $$ = $2; }
%%

int main() {
    yyparse();
    return 0;
}

