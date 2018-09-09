defmodule PrettyTest do
  use ExUnit.Case
  doctest Helper.Pretty

  alias Helper.Pretty

  test "empty list or nil" do
    assert Pretty.format([]) == []

    assert Pretty.format(nil) == []
  end

  test "lexographical compare" do

    words = ~w/Long list of words so many of them Gotta count them all/

    sorted = Enum.sort(words, &Pretty.lexographical_compare/2)

    assert sorted == ~w/all count Gotta list Long many of of so them them words/
  end

  test "default format" do
    help = Pretty.format(:hello)

    assert help == "hello - returns `:world`"
  end

  test "custom format" do
    help = Pretty.format(:hello, "#{1 + 3}:f - :h")

    assert help == "4hello - returns `:world`"
  end

  test "alignment" do
    help = Helper.Pretty.format([:hello, :rem], ":f:a - :h")

    assert help == "hello - returns `:world`\nrem   - who is that?"
  end
end
