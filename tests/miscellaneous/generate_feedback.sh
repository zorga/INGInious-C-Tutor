#!/bin/bash
#This script takes a C source-file as argument and generate an extended feedback on its execution

SRCFILE=$1;
SUFIX=".c";
BASENAME=${SRCFILE%$SUFIX};

#Getting the Valgrind logs:
gcc -ggdb -O0 -fno-omit-frame-pointer $SRCFILE -o $BASENAME.o
if [ $? -ne 0 ]; then
  echo "Error during compilation";
  exit 1;
fi
../../valgrind-3.11.0/inst/bin/valgrind --tool=memcheck --source-filename=$SRCFILE --trace-filename=$BASENAME.vgtrace ./$BASENAME.o

#Generate the intermediate trace file:
if [ ! -e "$BASENAME.vgtrace" ]; then
  echo "Error while getting Valgrind log files";
  exit 1;
fi
python2.7 ../../src/generate_traces.py $BASENAME

#Generate the graphs:
mkdir -p img
mkdir -p dots

if [ ! -e "$BASENAME.trace" ]; then
  echo "Error while generating the trace file";
  exit 1;
fi
python2.7 ../../src/generate_graph_from_traces.py $BASENAME.trace

