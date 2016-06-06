#!/bin/bash
# Script used to run everything from Valgrind traces generation
# to final traces and images uploading to the server at the
# address : 130.104.78.197

cd ~/coding/code_thesis/tests/miscellaneous
echo ">>> generating trace file...";
make clean
make
cd ~/coding/code_thesis/
echo ">>> generating images...";
make clean
make
echo ">>> copying images to web server..."
scp -r img/* inginious@130.104.78.197:/var/www/html/execution_images/
echo ">>> copying trace file to web server..."
scp ~/coding/code_thesis/tests/miscellaneous/thesis_LinkedList.trace inginious@130.104.78.197:/var/www/html/
echo "URL : localhost:9000/demo.html";
echo "done";
