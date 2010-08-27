# program name
PROG = cpptolua

# compiler
CC = g++

.PHONY: tests clean all

all: $(PROG)
	#./$(PROG) < in.cpp
	#./$(PROG) < player.h

tests:
	cd tests/ ; make

$(PROG): y.tab.c lex.yy.c
	$(CC) $^ -o $@

y.tab.c: $(PROG).y
	yacc -d $<

lex.yy.c: $(PROG).l
	lex $<

%_userdata: %.h
	./$(PROG) -i $< -o $@.cpp
	./$(PROG) -i $< -o $@.h -H

clean:
	rm -f *~ y.tab.? lex.yy.c
