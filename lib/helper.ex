defmodule Helper do
  alias Helper.Store

  defmacro __using__(_opts) do
    quote do
      def load_help do
        Helper.Store.load(__MODULE__)
      end
    end
  end

  def help do
    Store.all()
  end

  def help(names) do
    with {:ok, helps} <- Store.lookup(names) do
      helps
    end
  end
end
