#!/bin/sh

export PATH=/opt/cmake/bin:$PATH
export PROJECT_VERSION="1.0.0"

make --version
g++ --version
pwd
ls -la && \

./configure release && make clean && make all test package
ls -la

exit 0