#ifndef __DOG__H
#define __DOG__H

class Dog
{
	public:
		Dog ();
		~Dog ();

		void bark();
		void mate(Dog other);
		Dog giveBirth();
		Dog divideFood(Dog a, int food);
	private:
		int hp,mp;

};

#endif
