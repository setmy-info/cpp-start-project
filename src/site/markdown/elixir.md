# Elixir

Elixir software is part of the build like every other language: `./configure`, `make all`,
`ctest`, `make package`. Mix does the Elixir work; `mix.exs` in the project root, the place of
`pom.xml`, takes the name and the version from `CMakeLists.txt`.

| Source                                 | What happens                        | Installed into `/opt/setmy.info`      |
|----------------------------------------|-------------------------------------|---------------------------------------|
| `src/main/elixir/**/*.ex`              | compiled to BEAM, dependencies too  | `lib/elixir/<project>/<app>/ebin`     |
| `src/main/elixir/**/*.exs`             | copied                              | `lib/elixir/`                         |
| `src/main/elixir/bin/*`                | copied: scripts and launchers       | `bin/`                                |
| `src/main/resources/elixir/config.exs` | compile time configuration          | in the BEAM files                     |
| `src/test/elixir/**/*_test.exs`        | ExUnit, run by `ctest`              |                                       |
| `src/main/man/elixir/manN/*`           | gzipped                             | `man/manN/`                           |

The build type decides the Mix environment: `prod` for `./configure release`, `dev` otherwise,
`test` for the tests. Mix works under `target/<build type>/mix` and `target/deps`; nothing is
written to the project root.

## Dependencies

Packages from hex.pm go into `deps` of `mix.exs`. They are fetched when the project is built and
installed with the application, each project in its own directory, so the machine that runs the
software downloads nothing and two projects can use different versions of one package. A build
without network uses the hex cache: `HEX_OFFLINE=1 make all`.

## Running

A launcher in `src/main/elixir/bin`, like `smi-example-elixir`, sets `ERL_LIBS` to the libraries of
the project, found relative to the launcher itself, and calls a function of the application with
the arguments. The elixir and Erlang
on `PATH` run it, so their versions on the machine have to be the ones the build used.
