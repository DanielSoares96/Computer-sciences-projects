CC = gcc
CFLAGS = -g
OUTFILE = yahh
LIBS = -lm


all: parser.c lexer.c yahh.o
	$(CC) $(CFLAGS) parser.c lexer.c yahh.o -o $(OUTFILE) $(LIBS)

parser.c: yah.y
	bison -y -d yah.y -o parser.c

lexer.c: yah.lex
	flex -o lexer.c yah.lex

yahh.o: yahh.h yahh.c
	gcc $(CFLAGS) -c yahh.c

run-1: 
	./yahh < exemplo1.ya

run-2: 
	./yahh < exemplo2.ya

run-3: 
	./yahh < exemplo3.ya


clean: 
	rm -rf parser.c lexer.c
	rm -f *~
	rm -f *.o
	rm -f yahh
