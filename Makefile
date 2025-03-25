CC = g++
LEX = flex
BISON = bison
CFLAGS = -std=c++11

all: lexer.tab.cpp parser.tab.cpp
	$(CC) $(CFLAGS) lexer.tab.cpp parser.tab.cpp -o calc

lexer.tab.cpp: lexer.l
	$(LEX) -o lexer.tab.cpp lexer.l

parser.tab.cpp: parser.y
	$(BISON) -d -o parser.tab.cpp parser.y

clean:
	rm -f lexer.tab.cpp parser.tab.cpp parser.tab.hpp calc

