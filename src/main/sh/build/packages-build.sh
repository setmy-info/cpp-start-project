#!/bin/sh

export PATH=/opt/cmake/bin:$PATH
export PROJECT_VERSION="1.0.0"

make --version
g++ --version
pwd
ls -la && \

./configure release && make clean && make all test package
ls -la
cat /var/opt/setmy-info/build/_CPack_Packages/Linux/RPM/rpmbuildcpp-start-project.err

exit 0