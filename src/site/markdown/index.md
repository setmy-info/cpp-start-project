# cpp-start-project

The documentation of the project, in markdown, in the place maven gives it: `src/site/markdown`.

* [Elixir](elixir.md) - how Elixir software is built, tested and installed.

`make all` copies these pages into the package, installed under `doc/<project>`. `make site`
builds the site under `target/site`: HTML when pandoc is installed, the markdown otherwise.
