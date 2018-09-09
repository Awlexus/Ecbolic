defmodule TestModule2 do
  use Ecbolic

  # This module should not be loaded outside of the test environment
  @on_load :not_prod
  def not_prod, do: if(Mix.env() != :prod, do: :ok)

  @doc help: "Repeats what you just said"
  def echo(string), do: string

end
