defmodule TestModule2 do
  use Ecbolic

  Ecbolic.help("Repeats what you just said")
  Ecbolic.usage("echo <text:str>")
  def echo(string), do: string
end
