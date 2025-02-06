%{
    #include "simple.tab.h"
%}

%%
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
";"         { return ';'; }
.           { printf("Unknown character: %s\n", yytext); }
%%

int yywrap() {
    return 1;
}