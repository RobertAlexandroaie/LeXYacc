%{
#include <stdio.h>
#include "y.tab.h"
%}

LITERE [a-zA-Z]+
CIFRA [0-9]
NUMAR [1-9]{CIFRA}*
SIR ["][^\n]*["]
ID {LITERE}[a-zA-Z0-9_]*
LTAB {NUMAR}(,{NUMAR})*

%%
"intreg"|"real"|"caracter"|"logic"|"complex"|"bit" {return TIP;}
"load."[a-zA-Z0-9]+ {return INCL;}
":)" {return BGIN;}
":(" {return END;}
"daca" {return DACA;}
"altfel" {return ALTFEL;}
"pentru" {return PENTRU;}
"cat timp" {return CATTMP;}
"<-" {return ASSIGN;}
"||"|"&&" {return LOP;}
"!" {return NOT;}
"^"|"&"|"|"|"<<"|">>" {return BOP;}
">"|">="|"<"|"<="|"=="|"<>" {return ROP;}
"c_"{ID} {return C_ID;}
"v_"{ID} {return V_ID;}
"struct_"{ID} {return STRUCT_ID;}
"s_"{ID} {return S_ID;}
"f_"{ID} {return F_ID;}
"vreaustruct" {return STRUCT;}
[{]{LTAB}[}] {return TABLOU;}
"retine " {return RETURN;}
"principal" {return MAIN;}
{SIR} {return SIR;}
{NUMAR} {return NUMAR;}

[ \t] ;
\n {yylineno++;}
. {return yytext[0];}

 
