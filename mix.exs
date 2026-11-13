defmodule Smi.MixProject do
  @moduledoc """
  The Elixir part of the project, in the maven layout of the rest of it:

      src/main/elixir/**/*.ex              compiled to BEAM
      src/main/elixir/**/*.exs             scripts, installed as they are
      src/main/elixir/bin/*                executable scripts
      src/main/resources/elixir/config.exs configuration
      src/test/elixir/**/*_test.exs        ExUnit tests

  The build runs Mix with the paths of the build type under target/: make all compiles, ctest
  tests. mix compile and mix test work from the command line as well, under target/mix.

  The application name and the version are the ones of CMakeLists.txt, so neither is written
  twice: PROJECT (cpp-start-project) is :cpp_start_project here. The build gives the version as
  SMI_PROJECT_VERSION, which carries -SNAPSHOT for a snapshot build.
  """
  use Mix.Project

  @cmake_lists File.read!(Path.join(__DIR__, "CMakeLists.txt"))

  def project do
    [
      app: app(),
      version: version(),
      elixir: "~> 1.15",
      elixirc_paths: ["src/main/elixir"],
      test_paths: ["src/test/elixir"],
      config_path: "src/main/resources/elixir/config.exs",
      build_path: "target/mix",
      deps_path: "target/deps",
      # Copies instead of symlinks in what is installed.
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [extra_applications: [:logger]]
  end

  # Fetched when the project is built, from hex.pm or the local hex cache (HEX_OFFLINE=1), and
  # installed with the application: nothing is downloaded on the machine that runs it.
  defp deps do
    []
  end

  defp app do
    [_, name] = Regex.run(~r/^PROJECT\s*\(\s*([A-Za-z0-9_.-]+)/m, @cmake_lists)
    name |> String.replace(~r/[^A-Za-z0-9_]/, "_") |> String.to_atom()
  end

  defp version do
    System.get_env("SMI_PROJECT_VERSION") ||
      ~w(MAJOR MINOR PATCH)
      |> Enum.map(fn part ->
        [_, number] = Regex.run(~r/^SET\s*\(PROJECT_VERSION_#{part}\s+(\d+)\s*\)/m, @cmake_lists)
        number
      end)
      |> Enum.join(".")
  end
end
