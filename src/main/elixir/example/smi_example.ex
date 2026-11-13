defmodule Smi.Example do
  @moduledoc """
  Example of compiled Elixir: built to BEAM by make all, installed under
  lib/elixir/<project>/<app>/ebin and started by the bin/smi-example-elixir launcher.
  """

  # The application this module belongs to, known when it is compiled: at runtime a launcher calls
  # main/1 before the application is loaded, when Application.get_application/1 has no answer.
  @app Mix.Project.config()[:app]

  @doc "The greeting for a name."
  @spec greet(String.t()) :: String.t()
  def greet(name) when is_binary(name), do: "Hello, #{name}!"

  @doc "Entry point of the launcher, with the command line arguments."
  @spec main([String.t()]) :: :ok
  def main(args) do
    {:ok, _} = Application.ensure_all_started(@app)

    case args do
      ["--version"] -> IO.puts(Application.spec(@app, :vsn))
      [] -> IO.puts(greet("World"))
      names -> Enum.each(names, &IO.puts(greet(&1)))
    end
  end
end
