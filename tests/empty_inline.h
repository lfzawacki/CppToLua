/*

	Tests for inlined code in a .h

*/

#include <stdio.h>

class Wizard
{
	public:
		Wizard (int h,int m) {  }
		~Wizard () { }

		void doMagic() {  }
		void wrathOfGod() {  }

	private:
		int hp, mp;
};
