#include "cat.h"

#include <stdlib.h>
#include <stdio.h>

bool Cat::makeCake()
{
	return 2*pancakeMix + 10;

}
void Cat::meow()
{
	printf("meow\n");

}

void Cat::sleepy()
{
	printf("zzz zz ");
	printf("Wake him up!\n");
	getchar();
}
