all: test01.graph

%.vgtrace: %.c ../../../valgrind-3.11.0/inst/bin/valgrind
	@gcc -ggdb -O0 -fno-omit-frame-pointer $< -o $(basename $@).o
	@../../../valgrind-3.11.0/inst/bin/valgrind --tool=memcheck --quiet --source-filename=$< --trace-filename=$(basename $<).vgtrace ./$(basename $<).o || true

%.trace: %.vgtrace ../../../generate_traces_tests.py
	@python2.7 ../../../generate_traces_tests.py $(basename $<) > $(basename $<).trace || true

%.graph: %.trace ../../../generate_graph_from_traces_tests.py
	@python2.7 ../../../generate_graph_from_traces_tests.py $(basename $<).trace
	        
clean:
	@rm -f *.trace *.vgtrace *.out *.o

.PRECIOUS: %.trace %.vgtrace
