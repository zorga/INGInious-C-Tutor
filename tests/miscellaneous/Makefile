%.vgtrace: %.c ../../valgrind-3.11.0/inst/bin/valgrind
	@gcc -ggdb -O0 -fno-omit-frame-pointer $< -o $(basename $@).o
	@../../valgrind-3.11.0/inst/bin/valgrind --quiet --tool=memcheck --source-filename=$< --trace-filename=$(basename $<).vgtrace ./$(basename $<).o

%.trace: %.vgtrace ../../src/generate_traces.py
	@python2.7 ../../src/generate_traces.py $(basename $<)

clean:
	@rm -f *.trace *.vgtrace *.out *.o

.PHONY: clean
.PRECIOUS: *.vgtrace *.trace
