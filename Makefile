# program name
PROG = cpptolua

# compiler
CC = g++

.PHONY: tests clean all

all: $(PROG)

tests: $(PROG)
	cd tests/ ; make

$(PROG): y.tab.c lex.yy.c
	$(CC) $^ -o $@

y.tab.c: $(PROG).y
	yacc -d $<

lex.yy.c: $(PROG).l
	lex $<

#example of how you should do it
#%_userdata: %.h
#	./$(PROG) -i $< -o $@.cpp
#	./$(PROG) -i $< -o $@.h -H

clean:
	rm -f *~ y.tab.? lex.yy.c
