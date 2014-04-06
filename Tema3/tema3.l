%{
#include <stdio.h>
#include "y.tab.h"
%}

cifra [0-9]
numar [1-9]{cifra}*|[0]

%%

{numar} {yylval.intval=atoi(yytext); return NR;}
[a-zA-Z_]+ {yylval.strval=yytext; return STR;}
"==" {return OP_C;}
[\t ] ;

\n {return 0;}
. {return yytext[0];}



