#include <stdio.h>
#include <stdlib.h>

extern "C" {

#include "lua.h"
#include "lauxlib.h"
#include "lualib.h"

}

#include "cat_userdata.h"

lua_State* openLua()
{
	//lua_State *L = lua_init();
	lua_State *L = lua_open();
	luaopen_base(L);   // opens the basic library
	luaopen_table(L);  // opens the table library
	luaopen_string(L); // opens the string library
	luaopen_math(L);   // opens the math library

	luaopen_Cat(L);

	return L;

}

void loadLuaFile(lua_State* L, const char *filename)
{
	int error = luaL_loadfile(L, filename);

	if(error)
      printf("Error opening file: %s\n",lua_tostring(L, -1));
    
	lua_pcall(L, 0, 0, 0);
}

int main()
{
	lua_State *L = openLua();
	loadLuaFile(L,"main.lua");
}
