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
`make install` / `make package`) with the maven directory structure:

```
CMakeLists.txt, configure       the build, like pom.xml; mix.exs for the Elixir part
src/main/cpp, src/test/cpp      C++, built by cmake; tests run by ctest
src/main/elixir                 Elixir: *.ex compiled to BEAM, *.exs scripts, bin/ executables
src/test/elixir                 ExUnit tests, run by ctest
src/main/sh                     POSIX shell: bin/, lib/, in/*.in configured, rpm/ and deb/ scriptlets
src/main/groovy, python, cl,    other interpreted languages: bin/* to bin, lib/ to lib
  cmd, erlang
src/main/java, src/test/java    Java, maven's own place
src/main/man/<module>/manN      man pages, gzipped into man/manN
src/main/rpm/<module>           spec file packages: configuration per environment and machine
src/main/resources              resources; cmake/ the build definition (*.cmake.in), elixir/ the Mix config
src/site/markdown, resources    documentation, installed to doc/<project>; make site
target/                         everything the build writes
```

Elixir: see [src/site/markdown/elixir.md](src/site/markdown/elixir.md).

No `.cmake` file is in git, every one is generated. The build definition is templates,
`*.cmake.in`, under `src/main/resources/cmake` and, for tests, `src/test/resources/cmake`; each
configure generates the `.cmake` files from them into `target/cmake` (same tree as under `src`),
and `CMakeLists.txt` includes only the generated ones. Edit the `.cmake.in` files. Both trees are
laid out the same way:

```
<phase>.cmake.in                       project wide part of a phase
<language>/<phase>.cmake.in            language wide part (optional)
<language>/<module>/<phase>.cmake.in   module part (optional)
```

A phase is one of `variables`, `sources`, `targets`, `dependencies`, `configure`, `lib`, `bin`,
`man`, `etc`, `var`, included in that order by `CMakeLists.txt`.

Languages and modules are found from the directories (`base` module first, then alphabetical), so
no file lists them:

* **New module** - add `src/main/resources/cmake/<language>/<module>/` with only the phase files
  it needs, and run `./configure` again.
* **New language** - the same with a new `<language>` directory; a language wide file is needed
  only for settings common to all its modules.
* **Removing** a module or language - delete its directory.

A language file that needs its modules earlier than after itself calls
`INCLUDE_MODULES_CMAKE_FILES(<language directory> <phase>)`, as `src/test/resources/cmake/cpp/sources.cmake.in`
does to collect the test sources.

Helpers from `src/main/resources/cmake/functions.cmake.in` for module files:

* `ADD_COPY_TARGET(<target> <destination> <glob>...)` - copies matching files, no-op without them.
* `ADD_COPY_DIRECTORY_TARGET(<target> <destination> <directory>)` - copies a directory tree.
* `ADD_MAN_TARGET(<target> <man directory> <section>...)` - copies and gzips man pages.
* `CONFIGURE_DIRECTORY(<directory> <destination>)` - configures every `*.in` file (`@VAR@` only).

Interpreted languages (`cmd`, `groovy`, `python`, `cl`, `elixir`, `erlang`) need no cmake file at
all: `src/main/<language>/bin/*` is copied to `bin` and `src/main/<language>/lib` to `lib`.

### Build helpers

* `src/main/sh/build/update-versions.sh 1.2.3` - sets the version in every file that has it.
* `src/main/sh/build/check-files.sh [/opt/setmy.info]` - checks an installed package.

## Spec file packages and deployment

Besides the main package that CPack builds, `make all` builds RPMs from hand written spec files:
configuration packages per runtime environment and machine, the way the configuration projects
(nginx, nftables, mosquitto, keycloak) build them, but here, with the rest of the build. The RPMs
are written to the project directory; `make clean` removes them.

```
src/main/rpm/<module>/*.spec        a spec, used as it is
src/main/rpm/<module>/*.spec.in     a spec with @VARIABLE@ placeholders
src/main/rpm/<module>/fedora/...    the files of the packages, *.in configured; with README.md and
                                    the rest of the module directory this is the Source0 tarball
```

`src/main/rpm/example` shows every part. A module is a directory, nothing lists it. Each spec
needs `Source0`, the tarball of its module directory, unpacked to the name of the tarball without
`.tar.gz` (`%autosetup -n %{srcname}-%{version}`).

**Placeholders.** At package build time: `@VARIABLE@` in `*.in` files, any cmake variable, and
every `SMI_*` environment variable of `./configure`, so a value the CI job sets reaches the
package. Specs also get the macros `%{smi_version}` (the project version, `1.0.0~SNAPSHOT` for a
snapshot), `%{smi_provider}`, `%{smi_prefix}` and `%{smi_var}`. At install time: the scriptlets,
for example `sed` over `# NB! TEST ONLY: ` lines, and `SMI_STAGE` (`published` or `draft`), which
`smi-incoming-deploy` sets. Secrets do not go into packages.

**Where a package goes.** A deploy target is a runtime environment, `local`, `dev`, `test`,
`prelive`, `live` (`SMI_ENVIRONMENTS`), or an environment and a machine role, `live-fe`,
`live-be`. A spec names its targets in its first lines; without the line its packages go to every
environment. The main package goes to `SMI_PACKAGE_DEPLOY_TARGETS`.

```
# smi-deploy-targets: test live-fe
```

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

**Moving a configuration project here.** For a project with `rpm/*.spec`, `rpm/Makefile` and
`fedora/`:

```sh
mkdir -p src/main/rpm/nftables
cp -a ../nftables/fedora ../nftables/*.md ../nftables/rpm/*.spec src/main/rpm/nftables/
```

then put a `# smi-deploy-targets:` line on top of each spec, taken from the `SKIP_*` lists and
`*_HOST` variables of its `rpm/Makefile`, remove its `%doc` and `%license` lines, and set the
`SMI_DEPLOY_*_HOSTS` in Jenkins. No package installs into `/usr/share/doc`, the build stops on one
that does; documentation goes to `src/site`. Otherwise the specs stay as they are; a literal
`Version:` is updated by `update-versions.sh`.

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
