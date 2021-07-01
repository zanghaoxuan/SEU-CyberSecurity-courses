#ifndef HUGEINTEGER_H
#define HUGEINTEGER_H

#include<iostream>

class HugeInteger
{
public:
	void output();

	HugeInteger(int=0);
	HugeInteger(const char *);
	
	bool isEqualTo(const HugeInteger &);
	bool isNotEqualTo(const HugeInteger &);
	bool isLessThan(const HugeInteger &);
	bool isLessThanOrEqualTo(const HugeInteger &);
	bool isGreaterThan(const HugeInteger &);
	bool isGreaterThanOrEqualTo(const HugeInteger &);
	
	HugeInteger add(const HugeInteger &);
	HugeInteger add(int);
	HugeInteger add(const char *);
	
	HugeInteger substract(const HugeInteger &);
	HugeInteger substract(int);
	HugeInteger substract(const char *);
	
	bool isZero();
	
	int getLength();

protected:
	int integer[40];
};

#endif
