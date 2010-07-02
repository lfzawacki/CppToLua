#ifndef __NODE_H__
#define __NODE_H__

#include <string>
#include <vector>
#include <algorithm>
using namespace std;
//using std::string;

typedef struct sStringVec
{
	vector<string> vs;
} StringVec;

typedef struct sStringVecVec
{
	vector< vector<string> > vvs;
} StringVecVec;

typedef struct sIdf {
	string type;
	string name;
	bool isPublic;
	vector<sIdf> param;
} Idf;

typedef struct sNode {
	string s;
	vector<Idf> vi;
} Node;

extern bool member_scope_public;

#endif
