#!/bin/bash

# '$1' contains the program in arguments

# To test with 20 nodes linked lists :
DIR="./source_files";
# To test with 40 nodes linked lists :
#DIR="./lots_of_files";

prefix="./source_files/";
#prefix="./lots_of_files/";

TYPE=$1
GRAPH_NAME=$TYPE"_measure";
FILE=$TYPE".txt";

if [ -z $1 ]; then
  echo "NEED AN ARGUMENT";
  exit 1;
fi

# Clean up: 
rm *.txt;
rm *.csv;
cd $DIR;
rm *.o;
rm *.txt;
rm *.csv;
rm *.vgtrace;
rm *.trace;
rm vgcore*;
rm img/*;
rm dots/*;
cd ..;

if [ -f "$FILE" ]; then
  rm "$FILE";
fi

if [ -f "$GRAPH_NAME.png" ]; then
  rm "$GRAPH_NAME.png";
fi

# Tests:
i=0;
for file in $DIR/*;
do

  # Get measures for GCC
  if [ $TYPE == "gcc" ]; then
    
    sufix=".c";
    sourcefile=${file#$prefix}; # ex : test01.c
    binfile=${sourcefile%$sufix}; # ex : test01
    cd $DIR;
    output=$(/usr/bin/time -v gcc -ggdb -O0 -fno-omit-frame-pointer "$sourcefile" -o $binfile.o 2>&1 | tail -n +2 | head -n2);
    cd ..;

  # Get measures for Valgrind
  elif [ $TYPE == "valgrind" ]; then

    sufix=".c";
    sourcefile=${file#$prefix}; # ex : test01.c
    binfile=${sourcefile%$sufix}; # ex : test01
    cd $DIR;
    gcc_ouput=$(gcc -ggdb -O0 -fno-omit-frame-pointer $sourcefile -o $binfile.o)
    if [ $? -ne 0 ]; then
      echo "Error while compiling files";
      exit 1;
    fi
    VG="../../../valgrind-3.11.0/inst/bin/valgrind --tool=memcheck --quiet --source-filename=$sourcefile --trace-filename=$binfile.vgtrace ./$binfile.o";
    output=$(/usr/bin/time -v $VG 2>&1 | tail -n +2 | head -n2);
    cd ..;

  # Get measures for generate traces
  elif [ $TYPE == "trace" ]; then
     
    sufix=".c";
    sourcefile=${file#$prefix}; # ex : test01.c
    binfile=${sourcefile%$sufix}; # ex : test01
    cd $DIR;
    gcc_ouput=$(gcc -ggdb -O0 -fno-omit-frame-pointer $sourcefile -o $binfile)
    if [ $? -ne 0 ]; then
      echo "Error while compiling files";
      exit 1;
    fi
    VG="../../../valgrind-3.11.0/inst/bin/valgrind --tool=memcheck --quiet --source-filename=$sourcefile --trace-filename=$binfile.vgtrace ./$binfile";
    $VG;
    TRACE="python2.7 ../../../generate_traces.py $binfile"; 
    output=$(/usr/bin/time -v $TRACE 2>&1 | tail -n +2 | head -n2);
    mv $binfile $binfile.o
    rm $binfile.o
    cd ..; 

  # Get measures for generate graphs
  elif [ $TYPE == "graph" ]; then

    sufix=".c";
    sourcefile=${file#$prefix}; # ex : test01.c
    binfile=${sourcefile%$sufix}; # ex : test01
    cd $DIR;
    gcc_ouput=$(gcc -ggdb -O0 -fno-omit-frame-pointer $sourcefile -o $binfile)
    if [ $? -ne 0 ]; then
      echo "Error while compiling files";
      exit 1;
    fi
    VG="../../../valgrind-3.11.0/inst/bin/valgrind --tool=memcheck --quiet --source-filename=$sourcefile --trace-filename=$binfile.vgtrace ./$binfile";
    $VG;
    TRACE="python2.7 ../../../generate_traces.py $binfile"; 
    $TRACE
    mkdir -p ../img;
    mkdir -p ../dots;
    GRAPH="python2.7 ../../../generate_graph_from_traces_tests.py $binfile.trace";
    output=$(/usr/bin/time -v $GRAPH 2>&1 | tail -n +2 | head -n2);
    mv $binfile $binfile.o
    rm $binfile.o
    cd ..; 

  elif [ $TYPE == "all" ]; then

  cd $DIR;
	sufix=".c";
	sourcefile=${file#$prefix}; # ex : test01.c
	binfile=${sourcefile%$sufix}; # ex : test01
	if [ "$file" == "Makefile" ]; then
		continue;
	fi
  output=$(/usr/bin/time -v make $binfile.graph 2>&1 | tail -n +2 | head -n2);
  cd ..
  fi

  # processing the output
  user=$(echo "$output" | head -n1); 
  sys=$(echo "$output" | tail -n +2);
  all="$user $sys";
  echo "$i  $all" >> "$FILE";
  let "i=i+1";
done

# generate graph
./processing.py $FILE $TYPE
./make_plot.py $TYPE.csv $GRAPH_NAME


