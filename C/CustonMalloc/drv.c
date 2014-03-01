#include <stdio.h>
#include <unistd.h>
#include "mymalloc.h"

int *a;
int *c;
int *b;
int *d;
int *e;
int *f;
int *g;
int main(){

	printf("The origional value of break is %p\n",sbrk(0));
	a = my_worstfit_malloc(10);
	printf("value of break after first 10 is %p\n",sbrk(0));
	b = my_worstfit_malloc(10);
	printf("value after second 10 is %p\n",sbrk(0));
	c = my_worstfit_malloc(10);
	printf("value after third 10 is %p\n",sbrk(0));
	my_free(b);
	d = my_worstfit_malloc(1);
	printf("start of d is %p and it has a size of 1",d);
	my_free(c);
	

	/*d = my_worstfit_malloc(10);
	e = my_worstfit_malloc(10);
	f = my_worstfit_malloc(10);
	(my_free(c);
	printf("c\n");
	my_free(e);
	printf("e\n");
	my_free(f);
	printf("f\n");
	my_free(d);
	printf("D\n");
	my_free(a);
	printf("a\n");
	my_free(b);
	printf("b\n");*/
	

	printf("Break after freeing is  %p\n",sbrk(0));
return 0;
}
