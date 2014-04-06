%{
#include <stdio.h>
#include <string.h>
%}
%union {
int intval;
char* strval;
}
%token OP_C
%token <strval>STR <intval>NR 
%type <intval>num
%type <strval>sir

%start s

%nonassoc '|' OP_C
%left '+' '-'
%left '/' '*' '#' '`' '?'


%%
s :	sir  	{
				if(strcmp($1,"!")==0)
					printf("Avertisment! Sir sau numar eronat!\n");
				else
					printf("Rezultatul final este: %s\n",$<strval>$);
			}
  |	num		{
				if($1==-1)
					printf("Avertisment! Sir sau numar eronat!\n");
				else
					printf("Rezultatul final este: %d\n",$<intval>$);
			}
  ;

num:	NR				{$$=$1;}
	|	num '+' num	{
						if($1==-1)
						{
							printf("Avertisment! Sir sau numar eronat!(num -> num + num)\n");
							$$=-1;
						}
						else
							$$=$1+$3;
					}
	|	num '-' num	{
						if($1==-1)
						{
							printf("Avertisment! Sir sau numar eronat!(num -> num - num)\n");
							$$=-1;
						}
						else
							$$=$1-$3;
					}
	|	num '*' num	{
						if($1==-1)
						{
							printf("Avertisment! Sir sau numar eronat!(num -> num * num)\n");
							$$=-1;
						}
						else
							$$=$1*$3;
					}
	|	num '/' num	{
						if($1==-1)
						{
							printf("Avertisment! Sir sau numar eronat!(num -> num / num)\n");
							$$=-1;
						}
						else
							$$=$1/$3;
					}
	|	'(' num ')'	{$$=$2;}
	|	'|' sir '|' {
						if(strcmp($2,"!")==0)
						{
							printf("Avertisment! Sir sau numar eronat!(num -> |sir|)\n");
							$$=-1;
						}
						else
						{
							printf("S-a aplicat regula: sir->|sir|\n");
							int n=strlen($2);
							$$=n;
						}
					}
	| sir OP_C sir 	{
						if(strcmp($1,"!")==0||strcmp($3,"!")==0)
						{
							printf("Avertisment! Sir sau numar eronat!(num -> sir == sir)\n");
							$$=-1;
						}
						else
						{
							printf("S-a aplicat regula: sir==sir\n");
							if(strcmp($1,$3)!=0)
								$$=0;
							else
								$$=1;
						}
					}
	| sir '?' sir 	{
						if(strcmp($1,"!")==0||strcmp($3,"!")==0)
						{
							printf("Avertisment! Sir sau numar eronat!(num -> sir ? sir)\n");
							$$=-1;
						}
						else
						{
							printf("S-a aplicat regula: sir->sir?sir\n");
							char *a=malloc(sizeof(char)*strlen($1));
							char *b=malloc(sizeof(char)*strlen($3));
							strcpy(a,$1);
							strcpy(b,$3);
							char *p=strstr(a,b);
							int num=0;
							while(p)
							{
								num++;
								p=strstr(p+strlen(b),b);
							}
							$$=num;
						}
					}

	;
	
sir : sir '+' sir   {
						if(strcmp($1,"!")==0||strcmp($3,"!")==0)
						{
							printf("Avertisment! Sir sau numar eronat!(sir -> sir + sir)\n");
							$$="!";
						}
						else
						{
							printf("S-a aplicat regula: sir->sir+sir\n"); 
							char* a=malloc(sizeof(char)*(strlen($1)+strlen($3)));
							strcpy(a,$1); strcat(a,$3);
							$$=a;
						}
					}
    | sir '-' sir 	{
						if(strcmp($1,"!")==0||strcmp($3,"!")==0)
						{
							printf("Avertisment! Sir sau numar eronat!(sir -> sir - sir)\n");
							$$="!";
						}
						else
						{
							printf("S-a aplicat regula: sir->sir-sir\n");
							
							char *a=malloc(sizeof(char)*strlen($1));
							char *b=malloc(sizeof(char)*strlen($3));
														
							strcpy(a,$1);
							strcpy(b,$3);
						
							if(strcmp(a,"")==0) $$=a;
							else
								if(strcmp(b,"")==0) $$=a;
								else
								{
									if (strstr(a,b))
									{
										char *p=malloc(sizeof(char)*strlen(a));
										char *q;
					
										bzero(p,strlen(p));
										while(strstr(a,b)!=NULL)
										{
											q=strstr(a,b);
											strncat(p,a,strlen(a)-strlen(q));
											a=q+strlen(b);
										}
										strcat(p,a);
										$$=p;
									} 
									else 
										$$=$1;
								}
						}
					}
    | '(' sir ')'	{
						printf("S-a aplicat regula: sir->( sir )\n");
						$$=$2;
					}
    | sir '*' num	{
						if(strcmp($1,"!")==0||$3==-1)
						{
							printf("Avertisment! Sir sau numar eronat!(sir -> sir * num)\n");
							$$="!";
						}
						else
						{
							printf("S-a aplicat regula: sir->sir*NR\n");
							int i,n=$3;
							
							if(n!=0)
							{
								char* result=malloc(sizeof(char)*strlen($1)*n);
								for(i=1;i<=n;i++)
									strcat(result,$1);
								$$=result;
							}
							else
							{
								printf("Atentie! Inmultire cu 0!\n");
								$$=(char *)('!');
							}
						}
					}
    | sir '#' num  	{  
						if(strcmp($1,"!")==0||$3==-1)
						{
							printf("Avertisment! Sir sau numar eronat!(sir -> sir # num)\n");
							$$="!";
						}
						else
						{
							printf("S-a aplicat regula: sir->sir#NR\n");
							int i,n=$3;
							int size=strlen($1);
							
							if(n>size)
							{
								printf("Atentie! Nu sunt suficiente caractere !\n");
								$$=(char *)('!');
							}
							else
							{
								char *s=malloc(sizeof(char)*size);
								
								strcpy(s,$1);
								s=s+(size-n);
								
								$$=s;
							}
						}
					}
    | num '`' sir	{
						if($1==-1||strcmp($3,"!")==0)
						{
							printf("Avertisment! Sir sau numar eronat!(sir -> num ` sir)\n");
							$$="!";
						}
						else
						{
							printf("S-a aplicat regula: sir->NR`sir\n");
							
							if($1 > strlen($3))
							{
								printf("Atentie! Nu sunt suficiente caractere !\n");
								$$="!";
							}
							else
							{
								int n=$1,i;
								
								char* s=malloc(sizeof(char)*n);
								strncpy(s,$3,n);
								$$=s;
							}
						}
					}
    | STR 	{
				if(strcmp($1,"!")==1)
				{
					printf("Avertisment! Sir sau numar eronat!(sir -> STR)\n");
					$$="!";
				}
				else
				{			
					printf("S-a aplicat regula: sir->STR\n");
					char* s=malloc(sizeof(char)*strlen($1));
					strcpy(s,$1);
					$$=s;
				}
			}
    ; 			 
%%

int main()
{
	yyparse();
}    