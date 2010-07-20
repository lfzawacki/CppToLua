#include "cat_userdata.h"

Cat* toCat(lua_State *L, int index)
{
	Cat *c = (Cat*) lua_touserdata(L,index);
	if (c == NULL) luaL_typerror(L,index,"Cat");
	return c;
}

Cat* checkCat(lua_State *L, int index)
{
	Cat *c;
	luaL_checktype(L, index, LUA_TUSERDATA);
	c = (Cat*) luaL_checkudata(L, index, "Cat");
	if (c == NULL) luaL_typerror(L, index, "Cat");

	return c;
}

int Cat_tostring(lua_State *L)
{
	lua_pushfstring(L, "Meow: %p", lua_touserdata(L, 1));
 	return 1;
}

int Cat_gc(lua_State *L)
{
	Cat* c = toCat(L,1);

	c->sleep();

	if (c) delete c;

	return 0;
}

int Cat_sleep(lua_State* L) {
	Cat *c = (Cat*) lua_touserdata(L, 1);
	c->sleep();
	return 1;
}

int Cat_query(lua_State* L) {
	Cat *c = (Cat*) lua_touserdata(L, 1);
	c->query();
}

int Cat_meow(lua_State* L) {
	Cat *c = (Cat*) lua_touserdata(L, 1);
	c->meow();
}

int Cat_makeCake(lua_State* L) {
	Cat *c = (Cat*) lua_touserdata(L, 1);
	lua_pushnumber(L, c->makeCake());
	return 1;
}

int Cat_new(lua_State* L) {
	//size_t size = sizeof(Cat);
	Cat *p = new Cat();
	lua_pushlightuserdata(L,p); //newuserdata(L, size);

	luaL_getmetatable(L, "Cat");
	lua_setmetatable(L, -2);
	return 1;
}

const struct luaL_reg Catlib [] = {
	{"new", Cat_new },
	{ "sleep" , Cat_sleep },
	{ "query" , Cat_query },
	{ "meow" , Cat_meow },
	{ "makeCake" , Cat_makeCake },
	{NULL,NULL}
};
static const luaL_reg Cat_meta[] = {
	{ "__gc", Cat_gc },
	{ "__tostring", Cat_tostring },
	{NULL,NULL}
};

//this is wrong, see here http://lua-users.org/wiki/BindingWithMetatableAndClosures

int luaopen_Cat(lua_State *L) {
	luaL_newmetatable(L, "Cat");
	lua_pushstring(L, "__index");
	lua_pushvalue(L, -2);
	lua_settable(L, -3);
	luaL_openlib(L, NULL, Cat_meta, 0);
	luaL_openlib(L, "Cat", Catlib, 0);
	return 1;
}
