#ifndef RATIONALNUMBER_H
#define RATIONALNUMBER_H


class RationalNumber
{
public:	
	RationalNumber(int=0,int=1);
	
	RationalNumber operator+(const RationalNumber&);
	RationalNumber operator-(const RationalNumber&);
	RationalNumber operator*(const RationalNumber&);
	RationalNumber operator/(      RationalNumber&);

	bool operator> (const RationalNumber&) const;
	bool operator< (const RationalNumber&) const;
	bool operator>=(const RationalNumber&) const;
	bool operator<=(const RationalNumber&) const;
	
	bool operator==(const RationalNumber&) const;
	bool operator!=(const RationalNumber&) const;

	void printRational() const;
	
private:
	int n;
	int d;
	void reduction();	
};

#endif
