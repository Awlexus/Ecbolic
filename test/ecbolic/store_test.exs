defmodule StoreTest do
  use ExUnit.Case
  doctest Ecbolic.Store

  alias Ecbolic.Store

  test "returns names" do
    {:ok, groups} = Store.group_names()
    assert groups == [:default, :group]
  end
end
