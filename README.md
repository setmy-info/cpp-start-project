# cpp-start-project

## Preparations

All libraries are not decided for project jet

```sh
sudo dnf -y install boost-test boost-devel boost-program-options yaml-cpp-devel json-c-devel libyaml-devel
```

## Build

```sh
PROJECT_VERSION=1.0.0
./configure release
make clean
make all test package
sudo rpm -e cpp-start-project
sudo rpm -i cpp-start-project-${PROJECT_VERSION}.x86_64.rpm
```

All in single line:

```sh
PROJECT_VERSION=1.0.0 && ./configure release && make clean && make all test package && sudo rpm -e cpp-start-project && sudo rpm -i cpp-start-project-${PROJECT_VERSION}.x86_64.rpm
```

### Build options

**./configure** options

**ci** - synonyme for release

**release** -
verification (unit tests, integration tests incl. valgrind tests), release (no debug info) binaries, stripped, without
-SNAPSHOT, real paths in side scripts.

**skipITs** - like maven skipITS, that skips integration tests incl. valgrind tests.

**noSnapshot** - without -SNAPSHOT

**realPaths** - inside scripts real path used

## Adding class

Affected files are like these:

```
new file:   src/main/cpp/library/CommandLineParameters.cpp
new file:   src/main/cpp/library/include/CommandLineParameters.h
new file:   src/test/cpp/library/include/CommandLineParametersTest.h
modified:   src/main/resources/cmake/cpp/library/sources.txt
modified:   src/test/cpp/library/include/Tests.h
modified:   src/test/resources/cmake/cpp/library/tests.txt
```
