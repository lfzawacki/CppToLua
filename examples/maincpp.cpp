#include "lynx.h"

int main()
{
	Lynx *l = (Lynx*) malloc(sizeof(Lynx));

	//testing placement new
	new (l) Lynx();	

	l->checkFightPower();

	delete l;
}
