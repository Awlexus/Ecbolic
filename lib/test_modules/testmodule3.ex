defmodule TestModule3 do
  use Ecbolic

  # This module should not be loaded outside of the test environment
  @on_load :test_only
  def test_only, do: if(Mix.env() == :test, do: :ok)
  
  @doc help: "muda muda muda muda!"
  def ora_ora_ora_ora, do: "muda muda muda muda!"

end

