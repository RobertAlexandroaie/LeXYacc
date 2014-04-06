#include <stdio.h>
#include <stdlib.h>

typedef struct NodLlin {
	int elt;
	struct NodLlin *succ;
} NodLlin;
typedef struct Llin {
	NodLlin *prim;
	NodLlin *ultim;
} Llin;

int *p;

void listaVida( Llin* l )
{	l->ultim = 0;
	l->prim = 0;}



int insereaza( Llin *l, int n)
{
    NodLlin *p, *q;
    p=l->ultim;
    q = (NodLlin *)malloc(sizeof(NodLlin));
    if(!q) 
        {printf("Nodul nu a putut fi adaugat!");
        return 0;}
    q->elt=n;
    q->succ=NULL;
    if(p==NULL)
        {l->prim=q;
        l->ultim=q;}
    else 
        {p->succ=q;
        l->ultim=q;}
    return 0;}

void compara(Llin *l1, Llin *l2)
{   NodLlin *p1=l1->prim;
    NodLlin *p2=l2->prim;
    while (p1!=NULL && p2!=NULL && p1->elt==p2->elt)
    {p1=p1->succ;
    p2=p2->succ;}
    if(p1==NULL && p2==NULL) 
        printf("listele sunt egale\n");
    else printf("listele sunt diferite\n");}

void elibereaza()
{   NodLlin *p, *q;
    p=l->prim;
    while(p!=NULL)
	    {q=p->succ;
        free(p);
        p=q;}}


int main()
{
	int i,n,k;
	Llin lista1, lista2;
	listaVida(&lista1);
	listaVida(&lista2);
	printf("introduceti numarul de elemente din lista 1: ");
	scanf("%d",&k);
	for(i=0;i<k;i++)
         {printf("Inserati elementul %d: ",i+1);
         scanf("%d",&n);
	     insereaza(&lista1,n);}
	     
	printf("introduceti numarul de elemente din lusta 2: ");
	scanf("%d",&k);
    for(i=0;i<k;i++)
         {printf("Inserati elementul %d: ",i+1);
         scanf("%d",&n);
	     insereaza(&lista2,n);}

    compara(&lista1,&lista2);
    
    elibereaza(&lista1);
    elibereaza(&lista2);
    system("pause");
	return 0;
}

