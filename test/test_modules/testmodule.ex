defmodule TestModule do
  use Ecbolic

  @moduledoc false

  Ecbolic.help "returns `:world`"
  def hello, do: :world

  Ecbolic.help "General Kenobi"
  def hello_there, do: "General Kenobi"

  Ecbolic.help "who is that?"
  def rem, do: "who is that?"

  def meaningless, do: ""
end
