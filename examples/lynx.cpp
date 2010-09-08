#include "lynx.h"

Lynx::Lynx() : fightPower(9000)
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
		printf("It's over %d!!\n",getFightPower()-1);
}

int Lynx::getFightPower()
{
	return fightPower;
}

void Lynx::setFightPower(int power)
{
	fightPower = power;
}
