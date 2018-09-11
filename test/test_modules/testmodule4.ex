defmodule TestModule4 do
  use Ecbolic

  Ecbolic.group :group

  Ecbolic.help_short "this is a function inside of a group"
  def group_function, do: "Kono dio da!"

end
