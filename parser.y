%{
#include <iostream>
#include <unordered_map>
#include <vector>
using namespace std;

int yylex();

void yyerror(const char* s) {
  cerr << "Error: " << s << endl;
}

extern char* yytext;

vector<unordered_map<string, int>> scopes = {{}};

void enterScope() {
  scopes.push_back({});
}

void exitScope() {
  if (scopes.size() > 1) {
    scopes.pop_back();
  }
}

int getVar(const string& name) {
  for (auto it = scopes.rbegin(); it != scopes.rend(); ++it) {
    if (it->count(name)) return (*it)[name];
  }
  cerr << "Error: Undefined variable " << name << endl;
  return 0;
}

void setVar(const string& name, int value) {
  scopes.back()[name] = value;
}

%}

%union {
  int num;
  char* str;
}

%token <num> NUMBER
%token <str> IDENTIFIER
%token PLUS MINUS STAR SLASH OP CP EOL PRINT ASSIGN
%token EQ LT GT LEQ GEQ NEQ AND OR NOT TRUE FALSE
%token IF ELSE OB CB
%type <num> program statements statement expression_statement print_statement
%type <num> expression assignment logical_or logical_and equalty comparison term factor unary primary
%type <num> if_statement block

%nonassoc IF
%nonassoc ELSE
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
         | if_statement
         | block
         ;

block:
     OB EOL { enterScope(); } statements CB EOL { exitScope(); }
     ;

print_statement:
               PRINT expression { cout << "Milord proclaimeth: " << $2 << "!\n"; }

expression_statement:
                    expression { $$ = $1; }
                    ;


if_statement:
            IF OP expression CP block ELSE block { if ($3) { $$ =$5; } else { $$ = $7; }}
            | IF OP expression CP block { if ($3) { $$ = $5; }}
            ;

expression:
          assignment { $$ = $1; }
          ;

assignment:
          IDENTIFIER ASSIGN assignment { setVar($1, $3); $$ = $3; }
          | logical_or { $$ = $1; }
          ;

logical_or:
          logical_and OR logical_and { $$ = $1 || $3; }
          | logical_and { $$ = $1; }
          ;

logical_and:
           equalty AND equalty { $$ = $1 && $3; }
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
    term PLUS factor { $$ = $1 + $3; }
    | term MINUS factor { $$ = $1 - $3; }
    | factor { $$ = $1; }
    ;

factor:
      factor STAR unary { $$ = $1 * $3; }
      | factor SLASH unary { $$ = $1 / $3; }
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
       | IDENTIFIER { $$ = getVar($1); }
       | OP expression CP { $$ = $2; }
       ;

%%


int main() {
    yyparse();
    return 0;
}

