#ifndef COMPLEX_H
#define COMPLEX_H

#include<iostream> 

class Complex
{
	friend std::ostream &operator<<(std::ostream &,const Complex &);
	friend std::istream &operator>>(std::istream &,Complex &);
	
public:
	Complex(double=0.0,double=0.0);
	Complex operator+(const Complex&) const;
	Complex operator-(const Complex&) const;
	Complex operator*(const Complex&) const;
	Complex &operator=(const Complex&);
	bool operator==(const Complex&) const;
	bool operator!=(const Complex&) const;
	
private:
	double r;
	double i;
};

#endif
