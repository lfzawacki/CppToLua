#ifndef __LYNX__H
#define __LYNX__H

#include <stdlib.h>
#include <stdio.h>
#include "cat.h"

class Lynx : public Cat
{
	public:

		Lynx();
		~Lynx();

		void kamehameha();
		void checkFightPower();
		int getFightPower();
		void setFightPower(int power);

	private:
		int fightPower;
};

#endif //__LYNX__H
