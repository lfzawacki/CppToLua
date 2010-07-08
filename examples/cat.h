#ifndef __CAT__H
#define __CAT__H


#include <lua.h>
#include <lauxlib.h>
#include <lualib.h>

class Cat
{
	public:

		Cat();
		~Cat();

		int makeCake();
		void meow();
		void query();
		void sleep();

	private:
		bool pancakeMix;
		int hp, mp;
};

#endif //__CAT__H
