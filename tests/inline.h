/*

	Tests for inlined code in a .h

*/

#include <stdio.h>

class Wizard
{
	public:
		Wizard (int h,int m) { hp = h; mp = m; }
		~Wizard () { }

		void doMagic() { printf("I put on my robe and wizard hat\n"); }
		void wrathOfGod() { printf("OHHHHH SHHHHHHHH\n"); }

	private:
		int hp, mp;
};
