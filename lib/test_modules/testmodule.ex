defmodule TestModule do
  use Ecbolic

  # This module should not be loaded outside of the test environment
  @on_load :test_only
  def test_only, do: if(Mix.env() == :test, do: :ok)

  @doc help: "returns `:world`"
  def hello, do: :world

  @doc help: "General Kenobi"
  def hello_there, do: "General Kenobi"

  @doc help: "who is that?"
  def rem, do: "who is that?"

  def meaningless, do: ""
end
