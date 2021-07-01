#ifndef INTEGERSET_H
#define INTEGERSET_H

#include<cstring>

class IntegerSet
{
private:
    int k[101];
public:
    IntegerSet()
    {
        memset(k,0,sizeof(k));
    }

    IntegerSet(int*,int);

    void inputSet();
    void printSet() const;
    bool isEqualTo(IntegerSet) const;
    void insertElement(int);
    IntegerSet unionOfSets(IntegerSet) const;
    IntegerSet intersectionOfSets(IntegerSet) const;
    void deleteElement(int);
    
    void printEqual(bool);
};

#endif
