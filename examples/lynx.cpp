#include "lynx.h"

Lynx::Lynx()
{

}

Lynx::~Lynx()
{

}

void Lynx::kamehameha()
{
		printf("AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA\n");
		getchar();
		printf("AAAAAAAAAAAAAAAAAAAAAAAAaaaaaaaaaaaaaaaaaaaaaAAAAAAAAAAAAA!!!!!!!!!1!11!!!one!!!eleven!!\n");
}

void Lynx::checkFightPower()
{
		printf("What does the scouter say about his power level?\n");
		printf("It's over %d!!",getFightPower()-1);
}

int Lynx::getFightPower()
{
	return fightPower;
}
