%{
    #include <stdio.h>
    #include <stdlib.h>
%}

%token NUMBER

%%

program:
    | program statement
    ;

statement:
    | expr ';' {
        printf("Result: %d\n", $1);
    }
    ;

expr:
    expr '+' term { $$ = $1 + $3; }
    | expr '-' term { $$ = $1 + $3; }
    | term { $$ = $1; }
    ;

term:
    term '*' factor { $$ = $1 * $3; }
    | term '/' factor {
        if ($3 == 0) {
            yyerror("Division by zero");
            $$ = 0;
        } else {
            $$ = $1 / $3;
        }
    }
    | factor { $$ = $1; }
    ;

factor:
    '(' expr ')' { $$ = $2; }
    | NUMBER     { $$ = $1; }
    ;

%%

int main() {
    printf("Enter an expression ending with a semicolon:\n");
    yyparse();
    return 0;
}

void yyerror(const char *s) {
    fprintf(stderr, "Error: %s\n", s);
}