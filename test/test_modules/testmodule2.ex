defmodule TestModule2 do
  use Ecbolic

  Ecbolic.help "Repeats what you just said"
  def echo(string), do: string

end
