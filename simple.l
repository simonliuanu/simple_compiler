%{
    #include "simple.tab.h"
    #include <string.h>
%}

%%
"if"        { return IF; }
"else"      { return ELSE; }
"while"     { return WHILE; }
"print"     { return PRINT; }
"="         { return ASSIGN; }
"=="        { return EQ; }
"!="        { return NEQ; }
"<"         { return LT; }
">"         { return GT; }
[a-zA-Z_][a-zA-Z0-9_]* {
    yylval = strdup(yytext);
    return IDENTIFIER;
}
[0-9]+      {
    yylval = atoi(yytext);
    return NUMBER;
}
[ \t\n]+     ;
"+"         { return '+'; }
"-"         { return '-'; }
"*"         { return '*'; }
"/"         { return '/'; }
"("         { return '('; }
")"         { return ')'; }
"{"         { return '{'; }
"}"         { return '}'; }
";"         { return ';'; }
.           { printf("Unknown character: %s\n", yytext); }
%%

int yywrap() {
    return 1;
}