defmodule Smi.ExampleTest do
  use ExUnit.Case, async: true
  doctest Smi.Example

  test "greets a name" do
    assert Smi.Example.greet("Elixir") == "Hello, Elixir!"
  end
end
