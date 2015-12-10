#!/bin/bash

# Jacob Freck
# adapted from http://bitzuma.com/posts/compile-bitcoin-core-from-source-on-ubuntu/

mkdir -p src && cd src
git clone https://github.com/Dellvan7/measurespv.git
sudo apt-get install build-essential
wget http://download.oracle.com/berkeley-db/db-4.8.30.NC.tar.gz
echo '12edc0df75bf9abd7f82f821795bcee50f42cb2e5f76a6a281b85732798364ef  db-4.8.30.NC.tar.gz' | sha256sum -c
tar -xvf db-4.8.30.NC.tar.gz
cd db-4.8.30.NC/build_unix
mkdir -p build
BDB_PREFIX=$(pwd)/build
../dist/configure --disable-shared --enable-cxx --with-pic --prefix=$BDB_PREFIX
make install
cd ../..
sudo apt-get install autoconf libboost-all-dev libssl-dev libprotobuf-dev protobuf-compiler libqt4-dev libqrencode-dev libtool

cd bitcoin
git checkout measurespv
./autogen.sh
./configure CPPFLAGS="-I${BDB_PREFIX}/include/ -O2" LDFLAGS="-L${BDB_PREFIX}/lib/" --with-gui
make
sudo make install
