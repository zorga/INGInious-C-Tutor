#!/bin/bash

#This script takes a C source-file as argument and generate an extended feedback on its execution

#Display usage in case of error when running the script with bad arguments
usage() {
  echo "Usage : "
  echo "./generate_feedback clean : to remove all previous feedback files (img, trace, vgtrace, ...)"
  echo "./generate_feedback feedback source.c : to generate the extended feedback for the source.c program"
  exit 1
}
  
#Check that arguments are given:
if [ $# -eq 0 ]; then
  usage
  exit 1
fi

#If first command is "clean" remove all the generated files
if [ "$1" == "clean" ]; then
  #No second argument needed in this case:
  if [ $# -gt 1 ]; then
    usage
    exit 1
  fi

  if [ -e *.vgtrace ]; then
    rm *.vgtrace
  fi

  if [ -e *.trace ]; then
    rm *.trace
  fi

  if [ -e *.o ]; then
    rm *.o
  fi

  if [ -d "img" ]; then
    rm -rf img/
  fi

  if [ -d "dots" ]; then
    rm -rf dots/
  fi

  exit 0

#If first command is "feedback" check if the second argument is a .c file
elif [ "$1" == "feedback" ]; then

  #No file passed to the script:
  if [ $# -lt 2 ]; then
    usage
    exit 1
  fi

  #Argument file is not a .c file:
  if [[ $2 != *.c ]]; then
    usage
    exit 1
  else
    SRCFILE=$2
  fi

#Print usage in case of unrecognized command:
else
  usage
fi



SUFIX=".c"
BASENAME=${SRCFILE%$SUFIX}

#Compiling the code:
gcc_out=$(gcc -ggdb -O0 -fno-omit-frame-pointer $SRCFILE -o $BASENAME.o 2>&1)
if [ $? -ne 0 ]; then
  echo "Error during compilation"
  exit 1
fi

#Getting the Valgrind execution log file:
vg_out=$(../../valgrind-3.11.0/inst/bin/valgrind --tool=memcheck --source-filename=$SRCFILE --trace-filename=$BASENAME.vgtrace ./$BASENAME.o 2>&1)
if [ $? -ne 0 ]; then
  echo "Error while getting the valgrind log files"
  exit 1
fi

#Generating the intermediate trace file:
if [ ! -e "$BASENAME.vgtrace" ]; then
  echo "No Valgrind log file !"
  exit 1
fi

int_out=$(python2.7 ../../src/generate_traces.py $BASENAME 2>&1)
if [ $? -ne 0 ]; then
  echo "Error during trace file construction"
  exit 1
fi

#Generating the graphs:
#Creating the directories to keep the images and dot files if they do not exist
mkdir -p img
mkdir -p dots

if [ ! -e "$BASENAME.trace" ]; then
  echo "No intermediate trace file !"
  exit 1
fi

graph_out=$(python2.7 ../../src/generate_graph_from_traces.py $BASENAME.trace)
if [ $? -ne 0 ]; then
  echo "Error while building the graphs"
  exit 1
fi

exit 0
