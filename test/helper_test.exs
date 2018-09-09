defmodule HelperTest do
  use ExUnit.Case
  doctest Helper

  test "returns help for one or multiple function" do
    assert Helper.help(:hello) == "returns `:world`"

    assert Helper.help([:hello_there, :rem]) == %{
             hello_there: "General Kenobi",
             rem: "who is that?"
    }
  end


  test "returns help for all modules" do
    assert Helper.help() ==  
      %{
             hello_there: "General Kenobi",
             ora_ora_ora_ora: "muda muda muda muda!",
             hello: "returns `:world`",
             echo: "Repeats what you just said",
             rem: "who is that?"
      }
  end

end
