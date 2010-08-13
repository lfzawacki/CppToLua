# compiler
CC = g++
CC2L = ../cpptolua

LUA = -llua -Ilua-5.1.4/include -Llua-5.1.4/lib -ldl

OBJECTS = cat.o lynx.o
USERDATA_O = cat_userdata.o lynx_userdata.o
USERDATA_H = $(USERDATA_O:.o=.h)
USERDATA_CPP = $(USERDATA_O:.o=.cpp)
USERDATA = $(USERDATA_H) $(USERDATA_CPP) $(USERDATA_O)

all: $(USERDATA) $(OBJECTS) main.cpp
	$(CC) -o example $(USERDATA_O) $(OBJECTS) main.cpp $(LUA)

cpp: $(OBJECTS)
	$(CC) -o cppmain $(OBJECTS) maincpp.cpp

lynx.o: lynx.cpp
	$(CC) -c -o $@ $^ 

cat.o: cat.cpp
	$(CC) -c -o $@ $^

%_userdata.o: %_userdata.cpp
	$(CC) -c -o $@ $^ $(LUA)

%_userdata.cpp: %.h
	$(CC2L) -i $< -o $@
	
%_userdata.h: %.h
	$(CC2L) -i $< -o $@ -H
	
clean: 
	rm *.o
	rm *_userdata.*

