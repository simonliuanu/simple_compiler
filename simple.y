%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>

    #define SYMTAB_SIZE 1000

    int yylex();
    void yyerror(const char *s);

    struct symbol {
        char *name;
        int value;
    } symtab[SYMTAB_SIZE];
    int symtab_count = 0;

    int get_symbol_value(char *name);
    void set_symbol_value(char *name, int value);
%}

%union {
    int intval;
    char *strval;
}

%token <intval> NUMBER
%token <strval> IDENTIFIER
%token IF ELSE WHILE PRINT
%token ASSIGN EQ NEQ LT GT

%type <intval> expr term factor condition

%%

program:
    statement_list
    ;

statement_list:
    statement
    | statement_list statement
    ;

statement:
     expr ';' {
        printf("Result: %d\n", $1);
        exit(0);
    }
    | IDENTIFIER ASSIGN expr ';' {
        set_symbol_value($1, $3);
        free($1);
    }
    | PRINT expr ';' { printf("%d\n", $2); }
    | IF '(' condition ')' '{' statement_list '}' 
    | IF '(' condition ')' '{' statement_list '}' ELSE '{' statement_list '}'
    | WHILE '(' condition ')' '{' statement_list '}'
    ;

condition:
    expr EQ expr { $$ = $1 == $3; }
    | expr NEQ expr { $$ = $1 != $3; }
    | expr LT expr { $$ = $1 < $3; }
    | expr GT expr { $$ = $1 > $3; }
    ;

expr:
    expr '+' term { $$ = $1 + $3; }
    | expr '-' term { $$ = $1 - $3; }
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
    | IDENTIFIER { $$ = get_symbol_value($1); free($1); }
    ;

%%

int get_symbol_value(char *name) {
    for (int i = 0; i < symtab_count; i++) {
        if (strcmp(symtab[i].name, name) == 0) {
            return symtab[i].value;
        }
    }
    return 0;
}

void set_symbol_value(char *name, int value) {
    for (int i = 0; i < symtab_count; i++) {
        if (strcmp(symtab[i].name, name) == 0) {
            symtab[i].value = value;
            return;
        }
    }
    if (symtab_count >= SYMTAB_SIZE) {
        symtab[symtab_count].name = strdup(name);
        symtab[symtab_count].value = value;
        symtab_count++;
    } else {
        yyerror("Symbol table full");
    }
}


int main() {
    printf("Enter an expression ending with a semicolon:\n");
    yyparse();
    return 0;
}

void yyerror(const char *s) {
    fprintf(stderr, "Error: %s\n", s);
}