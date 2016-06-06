#!/bin/bash
# Script used to run everything from Valgrind traces generation
# to final traces and images uploading to the server at the
# address : 130.104.78.197

cd ./tests/miscellaneous
echo ">>> generating trace file...";
make clean
make
cd ~/coding/code_thesis
echo ">>> generating images...";
make clean
make

# Generating random number for student feedback dir uniqueness:
id=$RANDOM
dir="stud_feedback_$id"
echo "generating $dir directory..."
mkdir -p "$dir/execution_images"
cp -r img/* $dir/execution_images/
cp tests/miscellaneous/thesis_LinkedList.trace $dir
cp feedback_demo.html demo_$id.html
cp demo_$id.html $dir
echo "done"
echo "Now uploading the new dir to the web server:"
scp -r $dir inginious@130.104.78.197:/var/www/html/
echo "Deleting local files..."
rm -rf $dir
rm -f demo_$id.html
echo "URL : http://localhost:9000/stud_feedback_$id/demo_$id.html"
echo



