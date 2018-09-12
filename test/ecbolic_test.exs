defmodule EcbolicTest do
  use ExUnit.Case
  doctest Ecbolic

  test "returns help for one or multiple function" do
    assert Ecbolic.fetch_help(:hello) == "returns `:world`"

    assert Ecbolic.fetch_help([:hello_there, :rem]) == %{
             hello_there: "General Kenobi",
             rem: "who is that?"
           }
  end

  test "gets help for a group of commands" do
    assert Ecbolic.help_group(:group) == %{
             group_function: "this is a function inside of a group"
           }
  end

  test "Returns nil when function not found" do
    assert Ecbolic.fetch_help(:does_not_exist) == nil
  end

  test "Returns an empty map when functions not found" do
    assert Ecbolic.fetch_help([:does_not, :exist]) == %{}
  end

  test "Returns an empty list when the group was not found" do
    assert Ecbolic.help_group(:does_not_exist) == %{}
  end
end
