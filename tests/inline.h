/*

	Tests for inlined code in a .h and returning references
	Taken from http://rosettacode.org/wiki/Define_a_primitive_data_type#C.2B.2B
	made some modifications to remove exceptions

*/
#ifndef __TINY__INT__H
#define __TINY__INT__H

class tiny_int
{
	public:

	tiny_int(int i): value(i) {
		if (value < 1)
		  value = 1
		if (value > 10)
		  value = 10
	}

	operator int() const {
		return value;
	}

	tiny_int& operator+=(int i) {
		// by assigning to *this instead of directly modifying value, the
		// constructor is called and thus the check is enforced
		*this = value + i;
		return *this;
	}

	tiny_int& operator-=(int i) {
		*this = value - i;
		return *this;
	}

	tiny_int& operator*=(int i) {
		*this = value * i;
		return *this;
	}

	tiny_int& operator/=(int i)	{
		*this = value / i;
		return *this;
	}

	tiny_int& operator<<=(int i) {
		*this = value << i;
		return *this;
	}

	tiny_int& operator>>=(int i) {
		*this = value >> i;
		return *this;
	}
	tiny_int& operator&=(int i) {
		*this = value & i;
		return *this;
	}

	tiny_int& operator|=(int i) {
		*this = value | i;
		return *this;
	}

	private:
	unsigned char value; // we don't need more space
};

#endif
