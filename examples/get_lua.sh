#!/bin/sh

LUA_FOLDER=lua-5.1.4
LUA_FILE=$LUA_FOLDER.tar.gz
LUA_PATH=http://www.lua.org/ftp/$LUA_FILE

echo "Downloading lua...\n"
wget $LUA_PATH
tar -xf $LUA_FILE

echo -en "Making lua for linux\n"
#cd $LUA_FOLDER
#make linux

echo "Now cd to the lua folder and do a 'sudo make install'"
