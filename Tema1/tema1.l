%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
FILE *g, *f;

char apel_functie[100];
int nr_par;

typedef struct nod
{
	char val[100];
	struct nod *next;
}nod;

typedef struct lista
{
	nod *first,*last;
}lista;

void listavida(lista *lis)
{
	lis->first=NULL;
	lis->last=NULL;
}

void push(lista *lis,char *str)
{
	nod *n=(nod *)malloc(sizeof(nod));
	n->next=NULL;
	strcpy(n->val,str);
	
	if(lis->last!=NULL && lis->first!=NULL)
	{
		lis->last->next=n;
		lis->last=n;
	}
	else
	{
		lis->first=n;
		lis->last=n;
	}
}

void scriere(lista *lis)
{
	nod* p;
	for(p=lis->first;p!=NULL;p=p->next)
		fprintf(f,"%s ",p->val);
}

lista ID_var,ID_struct,ID_fct;

%}

%s var
%s var2
%s str
%s str2
%s point

cifra [0-9]
litera [a-zA-Z_]
tip "char"|"short"|"int"|"unsigned"|"long"|"float"|"double"|"void"
rezervat "auto"|"break"|"case"|"class"|"const"|"continue"|"default"|"do"|"else"|"enum"|"extern"|"for"|"goto"|"if"|"inline"|"main"|"register"|"return"|"signed"|"sizeof"|"static"|"struct"|"switch"|"typedef"|"union"|"void"|"volatile"|"while"
biblioteca "#"[ ]*"include"[ ]*"<"[ ]*{litera}+".h"?[ ]*">"
id {litera}({litera}|{cifra})*
intreg ([1-9]{cifra}*)|0
real (({cifra}+"."{cifra}+)([Ee][-]?{cifra}+)?)[Ll]?
hexa "0x"({cifra}|[ABCDEF])*
oct "0"[0-7]+
car '(\.|[^\'])+'
sir \"(\.|[^\"])*\"
com (\/\/.*\n)|(\/\*(.|\n)*\*\/)
spatii [ \t\n]*
param {id}|([-]?{intreg})|([-]?{real})|{hexa}|{oct}

%%
{tip} {BEGIN var; REJECT;}
<var>"*" {fprintf(yyout,"< * POINT>");}
<var>[ ]*{id}[(] {BEGIN 0; REJECT;}
<var>{id} {push(&ID_var,yytext); REJECT;}
<var>[=\(\{\}\)\[\]] {BEGIN var2; REJECT;}
<var2>[;)}\n] {BEGIN 0; REJECT;}
<var2>"," {BEGIN var; REJECT;}
<var>[;)}\n] {BEGIN 0; REJECT;}

"struct" {BEGIN str; REJECT;}
<str>[ ]*{id}[(] {BEGIN 0; REJECT;}
<str>{id} {push(&ID_struct,yytext); REJECT;}
<str>[=\(\{\}\)\[\]] {BEGIN str2; REJECT;}
<str2>[;)] {BEGIN 0; REJECT;}
<str2>"," {BEGIN str; REJECT;}
<str>[;)}\n] {BEGIN 0; REJECT;}

{id}[ ]*"("({param}*[ ]*","[ ]*)*{param}")" {push(&ID_fct,yytext); REJECT;}

{tip} {fprintf(yyout,"< %s TIP> ", yytext);}
{biblioteca} {fprintf(yyout,"< %s LIB> ", yytext);}
{rezervat} {fprintf(yyout,"< %s REZ> ", yytext);}
{sir} {fprintf(yyout,"< %s C_STRING> ", yytext);}
{id} {fprintf(yyout,"< %s ID> ", yytext);}
{intreg} {fprintf(yyout,"< %s C_INT> ", yytext);}
{real} {fprintf(yyout,"< %s C_FLOAT> ", yytext);}
{hexa} {fprintf(yyout,"< %s C_HEX> ", yytext);}
{oct} {fprintf(yyout,"< %s C_OCT> ", yytext);}
{car} {fprintf(yyout,"< %s C_CHAR> ", yytext);}
"->"|"." {fprintf(yyout,"< %s OP> ", yytext);}
";" {fprintf(yyout,"< %s PV> ", yytext);}
"," {fprintf(yyout,"< %s V> ", yytext);}
"+" {fprintf(yyout,"< %s OP_ADD> ", yytext);}
"++" {fprintf(yyout,"< %s OP_INC> ", yytext);}
"--" {fprintf(yyout,"< %s OP_DEC> ", yytext);}
"-" {fprintf(yyout,"< %s OP_DIF> ",yytext); }
"=" {fprintf(yyout,"< %s OP_ASSIGN> ", yytext);}
"*" {fprintf(yyout,"< %s OP_MUL> ", yytext); }
"/" {fprintf(yyout,"< %s OP_DIV> ", yytext);}
"%" {fprintf(yyout,"< %s OP_MOD> ", yytext);}
"+=" {fprintf(yyout,"< %s OP_ADD_A> ", yytext);}
"-=" {fprintf(yyout,"< %s OP_DIF_A> ", yytext);}
"*=" {fprintf(yyout,"< %s OP_MUL_A> ", yytext);}
"/=" {fprintf(yyout,"< %s OP_DIV_A> ", yytext);}
"%=" {fprintf(yyout,"< %s OP_MOD_A> ", yytext);}
"==" {fprintf(yyout,"< %s OP_EQ> ", yytext);}
"<=" {fprintf(yyout,"< %s OP_LEQ> ", yytext);}
">=" {fprintf(yyout,"< %s OP_GEQ> ", yytext);}
"<" {fprintf(yyout,"< %s OP_LESS> ", yytext);}
">" {fprintf(yyout,"< %s OP_GREATER> ", yytext);}
"!=" {fprintf(yyout,"< %s OP_L_DIF> ", yytext);}
"&&" {fprintf(yyout,"< %s OP_L_AND> ", yytext);}
"||" {fprintf(yyout,"< %s OP_L_OR> ", yytext);}
"<<" {fprintf(yyout,"< %s OP_B_LSHIFT> ", yytext);}
">> " {fprintf(yyout,"< %s OP_B_RSHIFT> ", yytext);}
"&" {fprintf(yyout,"< %s OP_B_AND> ", yytext);}
"|" {fprintf(yyout,"< %s OP_B_OR> ", yytext);}
"^" {fprintf(yyout,"< %s OP_B_XOR> ", yytext);}
"!" {fprintf(yyout,"< %s OP_B_NOT> ", yytext);}
"(" {fprintf(yyout,"< %s LPAR> ", yytext);}
")" {fprintf(yyout,"< %s RPAR> ", yytext);}
"[" {fprintf(yyout,"< %s LSPAR> ", yytext);}
"]" {fprintf(yyout,"< %s RSPAR> ", yytext);}
"{" {fprintf(yyout,"< %s LAC> ", yytext);}
"}" {fprintf(g,"< %s RAC> ", yytext);}
{com} ;
" " ;
%%

int main(int argc, char** argv){

listavida(&ID_var);
listavida(&ID_struct);
listavida(&ID_fct);

if(argc>0)
 yyin = fopen(argv[1],"r");

if(!(g = fopen("output1.txt","w")))
    fprintf(stderr,"eroare creare fisier!");
else
 yyout=g;
 
if(!(f = fopen("output2.txt","w")))
    fprintf(stderr,"eroare creare fisier!");
yylex();

fprintf(f,"Lista numelor de variabila: ");
scriere(&ID_var);
fprintf(f,".\n");


fprintf(f,"Lista numelor de struct: ");
scriere(&ID_struct);
fprintf(f,".\n");


fprintf(f,"Lista apelurilor de functie: ");
scriere(&ID_fct);
fprintf(f,".\n");
}