# cpp-start-project

## Build

```sh
./configure
make
make package
sudo rpm -e cpp-start-project
sudo rpm -i cpp-start-project-0.54.0-SN.rpm
```

All in single line:

```sh
./configure release && make clear clean && make all test package && sudo rpm -e cpp-start-project && sudo rpm -i cpp-start-project-0.54.0.x86_64.rpm
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
