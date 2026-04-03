CC = g++
CFLAGS = -O3

default: eqeq

all: eqeq pybindings

eqeq: main.cpp
	$(CC) $(CFLAGS) $< -o $@

pybindings: main.cpp
	$(CC) -c -fPIC $(CFLAGS) $< -o eqeq.o
	$(CC) -shared -Wl,-install_name,libeqeq.so $(CFLAGS) -o libeqeq.so eqeq.o

.PHONY: clean test

test: eqeq
	bash tests/test_cif_parsing.sh

clean:
	    rm -f eqeq.o eqeq libeqeq.so
