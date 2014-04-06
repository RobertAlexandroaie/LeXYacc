%{
#include <stdio.h>
extern FILE* yyin;
extern char* yytext;
extern int yylineno;
%}

%token INCL TIP BGIN END DACA ALTFEL PENTRU CATTMP ASSIGN LOP BOP ROP C_ID V_ID S_ID F_ID SIR NUMAR STRUCT TABLOU
%token RETURN NOT MAIN STRUCT_ID
%start PR

%left '+' '-'
%left '*' '/' '%'
%left LOP
%left ROP
%right NOT
%left BOP
%%
PR	: biblioteci structuri bloc_declaratii functii main{ printf("Program corect sintactic!\n"); }
	;
			
	
//BIBLIOTECI
biblioteci:	INCL biblioteci
			|INCL
			;
//STRUCTURI
structuri: decl_structura structuri
			|
			;

decl_structura: STRUCT STRUCT_ID BGIN declaratii END
				;
			
//DECLARATII
bloc_declaratii: 	BGIN declaratii END
					|
					;
declaratii:	TIP lista_identificatori_declaratie ';' declaratii
			|STRUCT_ID lsid ';' declaratii
			|TIP lista_identificatori_declaratie ';'
			|STRUCT_ID lsid ';'
			|decl_functii declaratii
			|decl_functii
			;
	
lsid: S_ID ',' lsid
	|S_ID
	;

	//FUNCTII
functii:	decl_functii functii
			|
			;

decl_functii:	tip_functie F_ID '(' lista_parametri_functie_decl ')' BGIN bloc END
				;

tip_functie:	TIP
				|STRUCT_ID
				;	
	
lista_parametri_functie_decl:	TIP id ',' lista_parametri_functie_decl
								|TIP id
								|STRUCT_ID S_ID ',' lista_parametri_functie_decl
								|STRUCT_ID S_ID
								|
								;
								
bloc: 	declaratii bloc_instructiuni
		|bloc_instructiuni
		|declaratii
		|
		;
		
bloc_instructiuni: instructiuni bloc_instructiuni
				|instructiuni
				;
instructiuni:	conditionale
				|iterative
				|atribuiri ';'
				|apel_fct ';'
				|RETURN capat ';'
				|RETURN SIR ';'
				;
atribuiri:	variabila ASSIGN expresii
			|variabila ASSIGN apel_fct
			;
expresii:	capat op expresii
			|'(' expresii ')'
			|capat
			|NOT expresii
			;
	
op:	'+'
	|'-'
	|'*'
	|'/'
	|'%'
	|ROP
	|LOP
	|BOP
	;

				
capat:	iden
		|NUMAR
		;	

apel_fct: 	F_ID '(' lista_param ')'
			;

lista_param:	param ',' lista_param
				|param
				|
				;

param:	variabila ASSIGN capat
 		|apel_fct
		|expresii
		;		
		
conditie_bool:	expresii
				|atribuiri
				;

conditionale:	DACA conditie_bool BGIN bloc END ALTFEL BGIN bloc END
				|DACA conditie_bool BGIN bloc END
				;

iterative:	PENTRU variabila ASSIGN capat','capat BGIN bloc END
			|CATTMP conditie_bool BGIN bloc END
			;

//MAIN
main:	MAIN BGIN bloc END
		;
		
//globals
id: 	V_ID
		|V_ID TABLOU
		;
		
iden:	variabila
		|C_ID
		;

identificator_declaratie:	id
							|iden ASSIGN NUMAR
							|iden ASSIGN variabila
							|iden ASSIGN SIR
							;
		
lista_identificatori_declaratie:	identificator_declaratie ',' lista_identificatori_declaratie
									|identificator_declaratie
									;

variabila:	S_ID'.'V_ID
			|V_ID
			|V_ID TABLOU
			|S_ID'.'V_ID TABLOU
			|S_ID'.'apel_fct
			|S_ID
			;
%%

int yyerror(char *s){
	printf("Eroare: %s la linia:%d - %s\n", s, yylineno, yytext);
}

int main(int argc, char ** argv){
	yyin = fopen(argv[1],"r");
	yyparse();
}
