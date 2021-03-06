%{
#include "y.tab.h"
#include "node.h"
#include <stdlib.h>
#include <assert.h>
	void yyerror(char *);
	int idf(char *s);
//#define DEBUG

%}


%%

"class" { return CLASS; }
[{};(),:] {
	yylval.s = strdup(yytext);
#ifdef DEBUG
	printf(": %c\n", *yytext);
#endif
	return *yytext;
}

"*"	{	return '*';	}

"const" ;
"&" ;

	/* identifiers */

[a-zA-Z_0-9~>&=]+ {
#ifdef DEBUG
	printf(": %s\n", yytext);
	printf("idf: %i\n", idf(yytext));
#endif
	return idf(yytext);
}

	/* skip whitespace */

[ \t\n\r]+ ;

	/* skip comments */

\/\/.* ;
\/\*([^*]|[\r\n]|(\*+([^*/]|[\r\n])))*\*+\/ ;
	
	/* ^#[^i].*$ ;*/
	/* include files and using directives */

^#.*$ ;
^using.*$ ;

	/* anything else is an error */
. {
	printf(": '%c'\n", *yytext);
	yyerror((char *)"invalid character");
}

%%

int yywrap(void) {
	return 1;
}

int idf(char *s)
{
	//printf("passou por aqui: %s\n", s);
	yylval.sv = new StringVec;
	yylval.sv->vs.push_back(string(yytext));
	//yylval.n = new Node;
	//yylval.n->s = string(yytext);

	char types[][99] = {"public", "private", "protected", ""};
	int i;
	
	// here we check if we're parsing public members
	// only those will be exposed to the lua scripts
	for(i = 0; types[i][0]; i++) {
		if(!strcmp(types[i], s)) {
			if(i == 0) { //public index on types vector
				member_scope_public = true;
			} else {
				member_scope_public = false;
			}
			return VISIBILITY;
		}
	}
	return IDF;
}
