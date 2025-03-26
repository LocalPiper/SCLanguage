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
%type <num> program statements statement assignment expression factor term assignment_statement print_statement

%left PLUS MINUS
%left STAR SLASH

%%

program:
       statements
       ;

statements:
          statement statements { $$ = $1; }
          | statement { $$ = $1; }
          ;

statement:
         print_statement EOL { $$ = $1; }
         | assignment_statement EOL { $$ = $1; }
         ;

print_statement:
               PRINT assignment { cout << "Milord proclaimeth: " << $2 << "!\n"; }

assignment_statement:
                    assignment { $$ = $1; }
                    ;


assignment:
          IDENTIFIER ASSIGN assignment { variables[$1] = $3; $$ = $3; }
          | expression { $$ = $1; }

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
      | OP assignment CP { $$ = $2; }
%%

int main() {
    yyparse();
    return 0;
}

