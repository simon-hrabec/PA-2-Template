CC=gcc
CFLAGS=-Wall -pedantic

all: bin/squares

bin/squares: src/prog.c
	mkdir -p bin
	$(CC) $(CFLAGS) src/prog.c -o bin/squares

test:
	@echo "No tests defined"

run: bin/squares
	./bin/squares

clean:
	rm -rf bin