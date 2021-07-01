#ifndef HUGEINT_H
#define HUGEINT_H

#include<iostream>

class HugeInt
{
	friend std::ostream &operator<<(std::ostream &,const HugeInt &);
//	friend istream &operator>>(istream &,HugeInt &);
public:
	HugeInt(long long=0 );
	HugeInt(const char *);
	
	HugeInt& operator=(const HugeInt &);
	
	bool operator==(const HugeInt &) const;
	bool operator!=(const HugeInt &) const;
	bool operator< (const HugeInt &) const;
	bool operator<=(const HugeInt &) const;
	bool operator> (const HugeInt &) const;
	bool operator>=(const HugeInt &) const;
	
	HugeInt operator+(const HugeInt &) const;
	HugeInt operator-(const HugeInt &) const;
	HugeInt operator*(const HugeInt &) const;
	HugeInt operator/(const HugeInt &) const;
	HugeInt operator%(const HugeInt &) const;
	
	int getLength() const;

protected:
	int integer[40];
};

#endif
