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
%token EQ LT GT LEQ GEQ NEQ AND OR NOT TRUE FALSE
%type <num> program statements statement expression_statement print_statement
%type <num> expression assignment equalty comparison term factor unary primary



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
         | expression_statement EOL { $$ = $1; }
         ;

print_statement:
               PRINT expression { cout << "Milord proclaimeth: " << $2 << "!\n"; }

expression_statement:
                    expression { $$ = $1; }
                    ;

expression:
          assignment { $$ = $1; }
          ;

assignment:
          IDENTIFIER ASSIGN assignment { variables[$1] = $3; $$ = $3; }
          | equalty { $$ = $1; }
          ;

equalty:
       comparison EQ comparison { $$ = $1 == $3; }
       | comparison NEQ comparison { $$ = $1 != $3; }
       | comparison { $$ = $1; }
       ;

comparison:
          term LT term { $$ = $1 < $3; }
          | term GT term { $$ = $1 > $3; }
          | term GEQ term { $$ = $1 >= $3; }
          | term LEQ term { $$ = $1 <= $3; }
          | term { $$ = $1; }
          ;

term:
    factor PLUS factor { $$ = $1 + $3; }
    | factor MINUS factor { $$ = $1 - $3; }
    | factor { $$ = $1; }
    ;

factor:
      unary STAR unary { $$ = $1 * $3; }
      | unary SLASH unary { $$ = $1 / $3; }
      | unary { $$ = $1; }
      ;

unary:
     MINUS unary { $$ = -$2; }
     | NOT unary { $$ = !$2; }
     | primary { $$ = $1; }
     ;

primary:
       FALSE { $$ = 0; }
       | TRUE { $$ = 1; }
       | NUMBER { $$ = atoi(yytext); }
       | IDENTIFIER { $$ = variables[$1]; }
       | OP expression CP { $$ = $2; }
       ;

%%


int main() {
    yyparse();
    return 0;
}

