CC=gcc
CFLAGS=-Wall -pedantic

all: bin/squares

bin/squares: src/prog.c
	mkdir -p bin
	$(CC) $(CFLAGS) src/prog.c -o bin/squares

.PHONY: test
test: bin/squares
	test/testscript.sh

.PHONY: run
run: bin/squares
	./bin/squares

.PHONY: clean
clean:
	rm -rf bin