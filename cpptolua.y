%{

#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>
#include <string.h>
#include <string>
#include <vector>
#include "node.h"
using namespace std;

#define YY_(x) (char *) (x)

int yylex(void);
void yyerror(char *);
void displayUsage();
void parseOptions(int argc, char **argv);

void writeUtilityFunctions();
void writeFunctionNames();
void writeHeaders(string className) ;
void writeTypePush(string type);
void writeConstructor(string className);

string makeVariableName(string type, int index)
{
	char *buffer = (char*) malloc( sizeof type.c_str() + sizeof "just_a_" + sizeof "_00" );
	sprintf(buffer,"just_a_%s_%01d" , type.c_str(), index );
	string ret = buffer;
	free(buffer);
	return ret;
}

/* if the member has public scope */
bool member_scope_public = false;
bool global_make_header = false;
bool global_has_super_class = false;

/* there should be only one class per file */
string global_class_name = "";
string global_super_class_name = "";
string global_file_name = "your_header_name_here.h";
string global_header_name = "your_header_name_here.h";

vector<string> global_function_names;

%}


/* yyval type */
%union {
	char *s;
	struct sNode *n;
	struct sStringVec *sv;
	struct sStringVecVec *svv;
	struct sIdf *i;
};

%token <sv> IDF
%token CLASS VISIBILITY
%type <sv> idf_list idf_list_opt
%type <svv> idf_comma_list idf_comma_list_opt
%type <i> function
%type <n> class_body

%%

program:

			directive_list_opt class
			;

class:
			CLASS IDF hierarchy_opt '{' class_body '}' ';'
			{

				string className = $2->vs[0].c_str();

				writeHeaders(className);

				if (global_class_name.empty())
					global_class_name = className;

				//$$ = className;
				//printf("ClassName: %s\n", className);
				for(int i=0; i<$5->vi.size(); i++)
				{
					string type = $5->vi[i].type;
					string fooName = $5->vi[i].name;

					if(type == "Constructor") {
					/* a constructor */

						// a destructor
						if(fooName[0] != '~')
							continue;

					writeConstructor(className);

					continue;
				}

				if ( fooName == "") {
					/*caso seja um enum*/
					continue;
				}

				if (fooName.substr(0, strlen("operator")) == "operator") {
					/*caso seja um operator*/
					continue;
				}

				if (!$5->vi[i].isPublic) {
					/* caso nao seja publico */
					continue;
				}

				global_function_names.push_back(fooName);

				printf("int %s_%s(lua_State* L)",className.c_str(), fooName.c_str() );

				if (!global_make_header) {

					printf("\n{\n\t%s *c = *(%s**) lua_touserdata(L, 1);\n", className.c_str(), className.c_str());

					for(int j=0; j<$5->vi[i].param.size(); j++)
					{			;
						string paramType = $5->vi[i].param[j].type;
						string paramName = $5->vi[i].param[j].name;
						if(paramType=="int" || paramType=="float" || paramType=="double")
							printf("\t%s %s = luaL_checknumber(L, %d);\n", paramType.c_str(), paramName.c_str(), j+2);
					}

					printf("\t");
					//uses the right lua_push* function based the type
					writeTypePush(type);

					//pushing the function and all the parameters
					printf("c->%s(", fooName.c_str());
					for(int j=0; j<$5->vi[i].param.size(); j++)
					{
						if(j>0) printf(", ");
						printf("%s", $5->vi[i].param[j].name.c_str());
					}
					printf(")");

					//if it's not void we've got to close a parentheses
					if(type != "void")
						printf(");\n");
					else
						printf(";\n");

					//returns 1 if there's something at the stack
					printf("\treturn %d;\n",type == "void" ? 0 : 1);

					printf("}\n\n");

					} else {
						printf(";\n");
					}

/*
printf("%s: %s %s( ", $2->vs[0].c_str(), $5->vi[i].type.c_str(), $5->vi[i].name.c_str());
for(int j=0; j<$5->vi[i].param.size(); j++)
 printf("%s %s ", $5->vi[i].param[j].type.c_str(), $5->vi[i].param[j].name.c_str());
printf(")\n");
*/
}
	}
;

directive_list_opt:
			'#' IDF directive_param_opt { /*$$ = $2;*/ }
			| { /*$$ = "";*/ }
			;

directive_param_opt:
			'<' IDF '>' { /*$$ = $2;*/ }
			| IDF { /*$$ = "";*/ }
			| { /*$$ = "";*/ }
			;

class_body:
			VISIBILITY ':' class_body { $$ = $3; }
			| function class_body { $$ = $2; $$->vi.push_back(*$1); }
			| idf_comma_list ';' class_body { $$ = $3; }
			| /* empty */ { $$ = new Node; }
			;

hierarchy_opt:
			':' VISIBILITY idf_comma_list { global_super_class_name = $3->vvs[0][0];
											global_has_super_class = true; }
			| /* empty */ { global_has_super_class = false; }
			;

idf_comma_list_opt:
			idf_comma_list { $$ = $1;  }
			| /* empty */   { $$ = new StringVecVec; }
			;

idf_comma_list:
			idf_list { $$ = new StringVecVec; $$->vvs.push_back($1->vs); }
			| idf_comma_list ',' idf_list { $$ = $1; $$->vvs.push_back($3->vs); }
			;

idf_list_opt:
			idf_list { $$ = $1; }
			| /* empty */{ $$ = new StringVec; }
			;

idf_list:
			idf_list IDF    { $$ = $1; $$->vs.push_back($2->vs[0]); }
			| IDF           { $$ = $1; }
			;

function:
			idf_list '(' idf_comma_list_opt ')' idf_list_opt function_body
			{

				$$ = new Idf;
				if($1->vs.size() >= 2) //se nao for construtor/destrutor, vai ter um tipo
					$$->type = $1->vs[$1->vs.size()-2];
				else
					$$->type = "Constructor";

				$$->name = $1->vs[$1->vs.size()-1];
				//for(int i=0; i<$1->vs.size(); i++)
				//printf("%s ", $1->vs[i].c_str());
				vector<Idf> vp;
				//printf("ClassName: %s\n", $1->vs[0].c_str());

				for(int i=0; i<$3->vvs.size(); i++)
				{
					Idf p;


					p.type = $3->vvs[i][0];
					p.name = makeVariableName(p.type,i);
					//p.name = $3->vvs[i][$3->vvs[i].size()-1];

					vp.push_back(p);
				}

				$$->param = vp;
				$$->isPublic = member_scope_public;
				/* This shows what functions are in the data structure
				printf("%s %s( ", $$->type.c_str(), $$->name.c_str());
				for(int i=0; i<$$->param.size(); i++)
				   printf("%s %s ", $$->param[i].type.c_str(), $$->param[i].name.c_str());
				printf(")\n");
				*/
				//for(int i=0; i<$3->vvs.size(); i++)
				//	 for(int j=0; j<$3->vvs[i].size(); j++)
					//printf("%s ", $3->vvs[i][j].c_str());
				//printf("\n");
				}

				| idf_list '{' '}' ';' { $$ = new Idf; } // for enum
				;

function_body:
			 ';'
			 | '{' block '}'
			 ;

block:
		 idf_list ';'
		 | idf_comma_list ';'
		 | '{' block '}'
		 | /* empty */
		 ;
%%

void displayUsage()
{
	printf("\tusage: ./cpptolua [.h file] <options>\n");
	printf("\t-i Specifies input file, reads from stdin if not present\n");
	printf("\t-o Specifies output file, writes to stdout if not present\n");
	printf("\t-H Tells cpptolua to make a header file instead of a .cpp\n");
	printf("\t-n Sets the name of the file to be included in the .cpp\n");
	printf("\t-N Sets the name of the file to be included in the header.\n\t(Only necessary if reading from stdin)\n");
	printf("\t-h Show this message\n");
}

void parseOptions(int argc, char **argv)
{
	char ch;

	while((ch = getopt(argc, argv, "hHi:o:n:N:")) != EOF) {
		switch(ch) {
			//display help
			case 'h':
				displayUsage();
				exit(0);
				break;

			//make a header instead of a cpp file
			case 'H':
				global_make_header = true;
				break;

			//input file
			case 'i':
				global_file_name = optarg;
				freopen(optarg,"r",stdin);
				break;

			//output file
			case 'o':
				freopen(optarg,"w",stdout);
				break;

			//name of the include in the .cpp
			case 'n':
				global_header_name = optarg;
				break;
			case 'N':
				global_file_name = optarg;
				break;
		}
	}

}

void writeUtilityFunctions()
{

		const char* c = global_class_name.c_str();

		//Class* toClass(lua_State *L, int index)
		//Utility to convert a userdata pointer to a Class pointer
		printf("%s* to%s(lua_State *L, int index)",c,c);
		if(!global_make_header)	 {
			printf("\n{\n\t%s *p = (%s*) lua_touserdata(L,index);\n",c,c);
			printf("\tif (p == NULL) luaL_typerror(L,index,\"%s\");\n",c);
			printf("\treturn p;\n}\n\n");
		}	else {
			printf(";\n");
		}

		//Class* checkClass(lua_State *L, int index)
		//Utility to check if a pointer in the stack is of type (*Class)
		printf("%s* check%s(lua_State *L, int index)",c,c);
		if (!global_make_header) {
			printf("\n{\n\t%s *p;\n",c);
			printf("\tluaL_checktype(L, index, LUA_TUSERDATA);\n");
			printf("\tp = (%s*) luaL_checkudata(L, index, \"%s\");\n",c,c);
			printf("\tif (p == NULL) luaL_typerror(L, index, \"%s\");\n",c);
			printf("\treturn p;\n}\n\n");
		} else {
			printf(";\n");
		}

		//int luaopen_Class(lua_State *L)
		//Function to open the library
		printf("int luaopen_%s(lua_State *L)",c);
		if (!global_make_header) {
			printf("\n{\n\tluaL_newmetatable(L, \"%s\");\n",c);
			if (global_has_super_class) {
				printf("\tluaL_getmetatable(L,\"%s\");\n",global_super_class_name.c_str());
			}
			printf("\tlua_pushstring(L, \"__index\");\n");
			printf("\tlua_pushvalue(L, -2);\n");
			//if we pushed the superclass metatable the real table is one position further in
			//the stack thus it may be -(3+1)
			printf("\tlua_settable(L, -%d);\n", 3 + (global_has_super_class ? 1 : 0) );
			printf("\tluaL_register(L, NULL, %s_meta);\n",c);
			printf("\tluaL_register(L, \"%s\", %slib);\n",c,c);
			printf("\treturn 1;\n}\n");

		} else {
			printf(";\n");
		}

}

void writeFunctionNames()
{

    const char* nullnull = "{NULL,NULL}";
    const char* c = global_class_name.c_str();

		if (!global_make_header) {
			printf("const struct luaL_reg %slib [] = {\n",c);
    		printf("\t{\"new\", %s_new },\n",c);
    		printf("\t%s\n};\n\n",nullnull);

			printf("static const luaL_reg %s_meta[] = {\n",c);

			vector<string>& fn = global_function_names;
			vector<string>::iterator i;
			for (i = fn.begin(); i != fn.end(); i++ ) {
		    printf("\t{ \"%s\" , %s_%s },\n", i->c_str(), c,i->c_str() );
			}
			printf("\t{\"__gc\", %s_gc },\n",c);
			printf("\t%s\n};\n\n",nullnull);

		}

}

void writeHeaders(string className)
{

	const char *disclaimer = "This file was automatically generated by cpptolua\n";

	printf("/*\n\tLua bindings for class %s\n\t%s\n*/\n\n",className.c_str(), disclaimer);


	if (global_make_header) {
		printf("#include \"%s\"\n\n",global_file_name.c_str());
		printf("extern \"C\" {\n");

		const char *headers[3] = { "lua.h" , "lauxlib.h" , "lualib.h" };

		for (int i=0; i < 3; ++i) {
			printf("\t#include \"%s\"\n",headers[i]);
		}

		printf("\n}\n\n");

	} else {
			printf("#include \"%s\"\n\n",global_header_name.c_str());
	}

}

void writeTypePush(string type)
{
	if(type == "bool")
		printf("lua_pushboolean(L, ");
	else if(type == "char*")
		printf("lua_pushstring(L, ");
	else if (type == "void")
		printf("");
	else if(type == "double" || type == "int" || type == "float")
		printf("lua_pushnumber(L, ");
	else //if (type == "UserDefinedClass" )
		//push userdatum
		printf("");

	//problema: enums devem ser tratados com pushnumber mas classes definidas pelo usuário
	//devem ser tratadas com pushlightuserdata. Como fazer????

}

void writeConstructor(string className)
{
	const char* cnc = className.c_str();

	printf( "int %s_new(lua_State* L)",cnc);

	if (!global_make_header) {
		printf( "\n{\n\t%s *p = new %s();\n",cnc,cnc);
		printf( "\t%s **q = (%s**) lua_newuserdata(L, sizeof p );\n",cnc);
		printf( "\t*q = p;\n" );
		printf( "\tluaL_getmetatable(L, \"%s\");\n",cnc);
		printf( "\tlua_setmetatable(L, -2);\n");
		printf( "\treturn 1;\n}\n\n");
	} else {
		printf(";\n");
	}

	printf( "int %s_gc(lua_State* L)",cnc);

	if (!global_make_header) {
		printf( "\n{\n\t%s **p = (%s**) lua_touserdata(L,1);\n",cnc);
		printf( "\tif (*p) delete *p;\n");
		printf( "\treturn 0;\n}\n\n" );
	} else {
		printf(";\n");
	}


}


int main(int argc, char **argv)
{

	parseOptions(argc,argv);
	yyparse();
	writeFunctionNames();
	writeUtilityFunctions();

	return 0;

}

void yyerror(char *s) {
	fprintf(stderr, "%s\n", s);
	exit(1);
}
