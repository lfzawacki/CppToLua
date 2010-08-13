#include "cat.h"


Cat::Cat() : pancakeMix(0)
{
	printf("Spawned a new kitteh\n");
}

Cat::~Cat()
{
	printf("The kitteh's gone to hell\n");
}

int Cat::makeCake()
{
	return 2*pancakeMix + 10;
}

void Cat::meow()
{
	printf("meow\n");
}

void Cat::query()
{
	printf("I CAN HAS CHEEZEBURGER?\n");
}

void Cat::sleep()
{
	printf("zzz zz    ");
	printf("Wake him up!\n");
	getchar();
}

void Cat::setPancakeMix(int pan)
{
	pancakeMix = pan;
}

int Cat::getPancakeMix()
{
	return pancakeMix;
}

void Cat::damage(int d)
{
	 hp = MAX(0,hp - d);
}

void Cat::magic()
{
	printf("poof\n");
}
