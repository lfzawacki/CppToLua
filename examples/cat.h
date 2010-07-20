#ifndef __CAT__H
#define __CAT__H

#include <stdlib.h>
#include <stdio.h>

class Cat
{
	public:

		Cat();
		~Cat();

		int makeCake();
		void meow();
		void query();
		void sleep();

		void setPancakeMix(int pan);
		int getPancakeMix();

		void damage(int d);
		void magic();

	private:
		int array[1024];
		int pancakeMix;
		int hp, mp;
};

#endif //__CAT__H