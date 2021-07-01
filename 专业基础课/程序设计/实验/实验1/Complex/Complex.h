#ifndef COMPLEX_H
#define COMPLEX_H

#include<iostream>
using std::ostream;
using std::istream;

class Complex
{
	friend ostream &operator<<(ostream &,const Complex &);
	
public:
	Complex(double=0.0,double=0.0);
	Complex operator+(const Complex&) const;
	Complex operator-(const Complex&) const;
	
private:
	double r;
	double i;
};

#endif
