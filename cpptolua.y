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

/* if the member has public scope */
bool member_scope_public = false;

/* there should be only one class per file */
string global_class_name = "";

vector<string> functionNames;

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

//problemas: herdar metodos de outras classes....
//           nao deve pegar metodos private ou protected.... DONE
//					 tratar tipos com mais de uma palavra (char *)
//					 tratar retorno de tipo composto (classe, diferenciar de enum)
//					quando o método tiver a palavra operator e nao for um operatorX() ele vai ignorar.... DONE

program:
			directive_list_opt class
			;

class:
			 CLASS IDF hierarchy_opt '{' class_body '}' ';'
			 {
				 
			     string className = $2->vs[0].c_str();

                 if (global_class_name.empty())
                    global_class_name = className;

				 //$$ = className;
			     //printf("ClassName: %s\n", className);
			     for(int i=0; i<$5->vi.size(); i++)
			     {
			         string type = $5->vi[i].type;
			         string fooName = $5->vi[i].name;

			         if(type == "Constructor") { 
                     /* um construtor */

                     if (fooName[0] != '~')
                        continue;

                        const char* cnc = className.c_str();

                        printf( "int %s_new(lua_state* L) {\n",cnc);
                        printf( "\tsize_t size = sizeof(%s);\n",cnc);
                        printf( "\t%s *p = (%s*) lua_newuserdata(L, size);\n",cnc,cnc);
                        printf( "\tluaL_getmetatable(L, \"%s\");\n",cnc);
                        printf( "\tlua_setmetatable(L, -2);\n");
                        printf( "\treturn 1;\n}\n");
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
			         
                     functionNames.push_back(fooName);
                     
                     printf("int %s_%s(lua_State* L) {\n",className.c_str(), fooName.c_str() );
					 printf("\t%s *c = (%s*) lua_touserdata(L, 1);\n", className.c_str(), className.c_str());
					 for(int j=0; j<$5->vi[i].param.size(); j++)
					 {			;
					 	string paramType = $5->vi[i].param[j].type;
					 	string paramName = $5->vi[i].param[j].name;
					 	if(paramType=="int" || paramType=="float" || paramType=="double")
					 	    printf("\t%s %s = luaL_cheenumenumcknumber(L, %d);\n", paramType.c_str(), paramName.c_str(), j+2);
					 }

					 printf("\t");
					 if(type == "boolean")
					 	printf("lua_pushboolean(L, ");
					 else if(type == "char*")
					 	printf("			;lua_pushstring(L, ");
					 else //if(type == "double" || typenume == "int" || type == "float")
					 	printf("lua_pushnumber(L, ");
					 //problema: enums devem ser tratados com pushnumber mas classes definidas pelo usuário
					 //devem ser tratadas com pushlightuserdata. Como fazer????

					 printf("c->%s(", fooName.c_str());
					 for(int j=0; j<$5->vi[i].param.size(); j++)
					 {
					    if(j>0) printf(", ");
					 	printf("%s", $5->vi[i].param[j].name.c_str());
					 }
					 printf(")");

					 if(type != "void") printf(");\n");
					 else printf(";\n");

                     printf("}\n\n");
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
						 ':' VISIBILITY idf_comma_list
						 | /* empty */
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
						| /* empty */					{ $$ = new StringVec; }
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
				   //  printf("%s ", $1->vs[i].c_str());
				   vector<Idf> vp;			    
					 //printf("ClassName: %s\n", $1->vs[0].c_str());
				   for(int i=0; i<$3->vvs.size(); i++)
			   	   {
			   	 	  Idf p;
			   	 	  p.type = $3->vvs[i][$3->vvs[i].size()-2];
			   	 	  p.name = $3->vvs[i][$3->vvs[i].size()-1];
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


void writeFunctionNames()
{

    const char* nullnull = "{NULL,NULL}";
    const char* c = global_class_name.c_str();
    printf("const struct luaL_reg %slib [] = {\n",c);
    printf("\t{\"new\", %s_new },\n",c);
    printf("\t%s\n};\n",nullnull);

    printf("static const luaL_reg %s_meta[] = {\n",c);
        vector<string>::iterator i;      
        for (i = functionNames.begin(); i != functionNames.end(); i++ ) {
            printf("\t{ \"%s\" , %s_%s }\n", i->c_str(), c,i->c_str() );        
        }
    printf("\t%s\n};\n\n",nullnull);

    printf("int luaopen_%s(lua_State *L) {\n",c);
    printf("\tluaL_newmetatable(L, \"%s\")",c);
    printf("\tlua_pushstring(L, \"__index\");");
    printf("\tlua_pushvalue(L, -2);");
    printf("\tlua_settable(L, -3);");
    printf("\tluaL_openlib(L, NULL, %s_meta, 0);",c);
    printf("\tluaL_openlib(L, \"%s\", %slib, 0);",c,c);
    printf("return 1;\n}\n");

}

int main(int argc, char **argv)
{
	if(argc == 2) {
		//class_name_received = true;
		//class_name = argv[1];
	}
	yyparse();
    writeFunctionNames();
	return 0;
}

void yyerror(char *s) {
	fprintf(stdout, "%s\n", s);
}
