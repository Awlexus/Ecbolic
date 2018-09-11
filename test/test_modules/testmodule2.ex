defmodule TestModule2 do
  use Ecbolic

  Ecbolic.help_short "Repeats what you just said"
  def echo(string), do: string

end
