#ifndef __CAT_USERDATA_H__
#define __CAT_USERDATA_H__

extern "C" {

#include "lua.h"
#include "lauxlib.h"
#include "lualib.h"

}

#include "cat.h"

int Cat_sleep(lua_State* L);
int Cat_query(lua_State* L);
int Cat_meow(lua_State* L);
int Cat_makeCake(lua_State* L);
int Cat_new(lua_State* L);
int luaopen_Cat(lua_State *L);

#endif /* __CAT_USERDATA_H__ */
