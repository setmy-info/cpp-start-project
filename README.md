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

## Project layout

The build is the traditional configure, build, install cycle (`./configure`, `make`,
`make install` / `make package`) with the maven directory structure. The whole build is the one
`CMakeLists.txt`: there is no other cmake file, nothing is generated from a template and no file
is copied with placeholders filled in. The sources are used as they are.

```
CMakeLists.txt, configure       the build, like pom.xml; mix.exs for the Elixir part
src/main/cpp, src/test/cpp      C++; tests run by ctest
src/main/elixir                 Elixir: *.ex compiled to BEAM, *.exs scripts, bin/ executables
src/test/elixir                 ExUnit tests, run by ctest
src/main/sh                     POSIX shell: bin/, lib/, etc/, rpm/ and deb/ install scripts
src/main/groovy, python, cl,    other interpreted languages: bin/* to bin, lib/ to lib
  cmd, erlang
src/main/java, src/test/java    Java, maven's own place
src/main/man/<module>/manN      man pages, gzipped into man/manN
src/main/config/<package>       configuration packages, an RPM each
src/main/resources/elixir       the Mix configuration
src/site/markdown, resources    documentation, installed to doc/<project>; make site
target/                         everything the build writes
```

Modules are directories, found when the project is configured: a new man page module, language
library, configuration package or Elixir module is a new directory and `./configure`. What the
build tree has is what the main package installs, so nothing lists files either. Only the C++
targets are named in `CMakeLists.txt`; their sources are the `*.cpp` files of the module
directory, so a new class needs no edit there.

Scripts find what they need relative to themselves: the build tree has the layout of the
installation (`bin`, `lib`, `man`, `etc`, `doc`), binaries find their libraries in `../lib`, and
`bin/example` runs `bin/example.bin` in both. The version reaches C++ as compile definitions,
`PROJECT_MODULE_VERSION_*` (see `Version.h`).

Elixir: see [src/site/markdown/elixir.md](src/site/markdown/elixir.md).

### Build helpers

* `src/main/sh/build/update-versions.sh 1.2.3` - sets the version in every file that has it.
* `src/main/sh/build/check-files.sh [/opt/setmy.info]` - checks an installed package.

## Configuration packages and deployment

`make package` builds, beside the main package, one RPM per directory of `src/main/config`, with
CPack like the main package and without a spec file:

```
src/main/config/<package>/
    etc/..., usr/...       installed at / as they are; the files below etc are %config(noreplace)
    description            first line the summary, the rest the description
    requires, conflicts    one package per line, a version allowed: nginx >= 1.20
    deploy-targets         where it is deployed: test live-fe; every environment without it
    pre.install.sh, post.install.sh, pre.uninstall.sh, post.uninstall.sh   scriptlets ($1 as rpm)
```

`src/main/config/smi-example-config` and `smi-example-config-test` show every part. A setting of
one environment is written into the files of that package, or switched on at install time by its
scriptlet, as the `# NB! TEST ONLY: ` lines are; `SMI_STAGE` (`published` or `draft`) is set by
`smi-incoming-deploy`.

**Where a package goes.** A deploy target is a runtime environment, `local`, `dev`, `test`,
`prelive`, `live` (`SMI_ENVIRONMENTS`), or an environment and a machine role, `live-fe`,
`live-be`. The main package goes to `SMI_PACKAGE_DEPLOY_TARGETS`, every environment by default.

**Deployment.** With `smi-deploy` of setmy-info-scripts, which uploads to the machine and hands the
package to `setmy-info-deploy.path`, which installs it with `smi-incoming-deploy`:

```sh
make upload-test      # copy the packages to the upload directory of the test machines
make handover-test    # move them into the incoming directory, which installs them
make deploy-test      # both
make deploy-live      # live, then every live-<role>
SMI_DEPLOY_STAGE=draft make handover-live   # to incoming/draft instead
make deploy-help      # every target and its packages
```

The machines are not in the repository: `SMI_DEPLOY_<TARGET>_HOSTS` (`SMI_DEPLOY_TEST_HOSTS`,
`SMI_DEPLOY_LIVE_FE_HOSTS`), `[user@]host[:port]`, several separated by spaces, set in Jenkins.
`SMI_DEPLOY_<TARGET>_USER`, `_PORT`, `_REMOTE_DIR` and `_INCOMING_DIR` override the smi-deploy
defaults for one target. Packages go in dependency order, the ones others require first. The
`Jenkinsfile`, from jenkinsfile-starter, runs these targets per branch and environment.

## Adding class

Affected files are like these, no build file among them:

```
new file:   src/main/cpp/library/CommandLineParameters.cpp
new file:   src/main/cpp/library/include/CommandLineParameters.h
new file:   src/test/cpp/library/include/CommandLineParametersTest.h
modified:   src/test/cpp/library/include/Tests.h
```

A new test suite also gets its `ADD_TEST` lines in section 6 of `CMakeLists.txt`.

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
