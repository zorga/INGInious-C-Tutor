# Script to install the modified Valgrind version
cd valgrind-3.11.0
./autogen.sh && ./configure --prefix=`pwd`/inst && make && make install
