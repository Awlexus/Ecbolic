defmodule Ecbolic do
  alias Ecbolic.{Store, Help}

  defmacro __using__(_opts) do
    quote do
      def load_help do
        Ecbolic.Store.load(__MODULE__)
      end
    end
  end

  def help do
    Store.all()
    |> Enum.map(fn %Help{help_alias: name, help: help} -> {name, help} end)
    |> Enum.into(%{})
  end

  def help(names) when is_list(names) do
    with {:ok, help_entries} <- Store.lookup(names) do
      help_entries
      |> Enum.map(& {&1.help_alias, &1.help})
      |> Enum.into(%{})
    end
  end

  def help(name) do
    with {:ok, help_entry} <- Store.lookup(name),
         %Help{help: help} <- help_entry do
      help
    end
  end

  def help_group(group_name) do
    with {:ok, group} <- Store.group(group_name) do
      group
    end
  end
end
