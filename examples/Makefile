# compiler
CC = g++

LUA = -llua -Ilua-5.1.4/include -Llua-5.1.4/lib

all: cat.o cat_userdata.o
	$(CC) -o example main.cpp cat.o cat_userdata.o $(LUA)

cat.o: cat.cpp
	$(CC) -c -o $@ $<

cat_userdata.o: cat_userdata.cpp
	$(CC) -c -o $@ $< $(LUA)

clean: 
	rm *.o

