defmodule TestModule do
  use Ecbolic

  @moduledoc false

  # This modules should not be loaded in production
  @on_load :not_prod
  def not_prod, do: if(Mix.env() != :prod, do: :ok)

  @doc help: "returns `:world`"
  def hello, do: :world

  @doc help: "General Kenobi"
  def hello_there, do: "General Kenobi"

  @doc help: "who is that?"
  def rem, do: "who is that?"

  def meaningless, do: ""
end
