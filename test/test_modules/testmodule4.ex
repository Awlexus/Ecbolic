defmodule TestModule4 do
  use Ecbolic

  @moduledoc help_group: :group

  @doc help: "this is a function inside of a group"
  def group_function, do: "Kono dio da!"

end
