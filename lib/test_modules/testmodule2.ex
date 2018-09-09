defmodule TestModule2 do
  use Helper

  # This module should not be loaded outside of the test environment
  @on_load :test_only
  def test_only, do: if(Mix.env() == :test, do: :ok)

  @doc help: "Repeats what you just said"
  def echo(string), do: string

end
