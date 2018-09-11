defmodule TestModule do
  use Ecbolic

  @moduledoc false

  Ecbolic.help_short "returns `:world`"
  def hello, do: :world

  Ecbolic.help_short "General Kenobi"
  def hello_there, do: "General Kenobi"

  Ecbolic.help_short "who is that?"
  def rem, do: "who is that?"

  def meaningless, do: ""
end
