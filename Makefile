SHELL := /bin/bash
LIBFILES := $(shell find lib -name \*.pm)
TESTFILES := $(wildcard t/*.t)

test: $(LIBFILES) $(TESTFILES)
	prove -l t | tee $@
