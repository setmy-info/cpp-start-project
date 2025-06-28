# cpp-start-project

## Preparations

All libraries are not decided for project jet

```sh
sudo dnf -y install boost-test boost-devel boost-program-options yaml-cpp-devel json-c-devel libyaml-devel valgrind
sudo dnf -y install libjpeg-devel libtiff libtiff-tools libtiff-devel libtiff gtk4 gtk4-devel ddd eog
sudo dnf -y install mosquitto-devel
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

**ci** - synonyms for release

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

## Experiments with Windows

export PATH=/c/pub/cmake-4.0.3-windows-x86_64/bin:$PATH
cd /C/sources/setmy.info/submodules/cpp-start-project
cmake -DVERIFY_USED=true -DPROJECT_IS_SNAPSHOT=true -DCONFIGURE_MODE=Real -DCMAKE_BUILD_TYPE=Debug .
cmake -DVERIFY_USED=true -DPROJECT_IS_SNAPSHOT=true -DCONFIGURE_MODE=Real -DCMAKE_BUILD_TYPE=Debug -DCMAKE_TOOLCHAIN_FILE=toolchain-mingw64.cmake .
cmake -G "MSYS Makefiles" -DVERIFY_USED=true -DPROJECT_IS_SNAPSHOT=true -DCONFIGURE_MODE=Real -DCMAKE_BUILD_TYPE=Debug .

## TODO

Mostly code from HASS:

* **has-lib-watchdog** (Fri Apr 12 22:26:34 2013 +0300)
* **cloudy-storage** (Sun Nov 18 18:16:53 2012 +0200)
* **has-id-db** (Mon Oct 22 23:27:01 2012 +0300)
* **has-sys-ai-cpp** (has-sys-developer Sun Apr 30 09:26:42 2017 +0300)
