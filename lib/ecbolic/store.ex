defmodule Ecbolic.Store do
  use GenServer

  require Logger

  alias Ecbolic.Help

  @moduledoc """
  This `GenServer` is responsible for storing all functions and 
  the related help-data. 
  """

  @typedoc """
  An entry used by `Ecbolic.Store` to store information about a
  function and related help-data
  """
  @type help :: %Ecbolic.Help{help: String.t(), help_alias: Ecbolic.atom_or_string, help_group: Ecbolic.atom_or_string}

  @doc false
  def start_link(opts) do
    opts = Keyword.put(opts, :name, __MODULE__)
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  @doc false
  def init(:ok) do
    {:ok, []}
  end

  @doc """
  Loads help from the given function.
  """
  @spec load(atom) :: :ok
  def load(module) do
    GenServer.call(__MODULE__, {:load_help, module})
  end

  @doc """
  Returns all stored help entries
  """
  @spec all() :: [help]
  def all do
    GenServer.call(__MODULE__, :all)
  end

  @doc """
  Returns all stored help entries, but mapped to their group
  """
  @spec all_grouped() :: {:ok, %{Ecbolic.atom_or_string => [help]}}
  def all_grouped do
    GenServer.call(__MODULE__, :all_grouped)
  end

  @doc """
  Returns the help entries for the asked actions. If a function
  is **not** found, it will be excluded from the returning list.
  This also means that if no function was found, it'll return an
  empty list.
  """
  @spec lookup([Ecbolic.atom_or_string]) :: {:ok, [help]}
  def lookup(functions) when is_list(functions) do
    GenServer.call(__MODULE__, {:lookup_multiple, functions})
  end

  @doc """
  Returns the help entry for the asked action. 
  """
  @spec lookup(Ecbolic.atom_or_string) :: {:ok, help} | {:error, String.t()}
  def lookup(action) do
    GenServer.call(__MODULE__, {:lookup, action})
  end

  @doc """
  Returns all help entries for a given group. An 
  empty list will be returned, if the group does
  not exist.

  Note: Ungrouped functions are given the 
  `:default`-group
  """
  @spec group(Ecbolic.atom_or_string) :: [help]
  def group(group) do
    GenServer.call(__MODULE__, {:group, group})
  end

  @doc """
  Returns a list of all group names.
  """
  @spec group_names() :: [Ecbolic.atom_or_string]
  def group_names do
    GenServer.call(__MODULE__, :group_names)
  end

  @doc """
  Clears the internal state of the store. 
  
  This is neccessary if you want to reload 
  the entries. If you try to do so, without
  calling this function first, you'll have 
  duplicated entries.
  """
  @spec clear_store() :: :ok
  def clear_store do
    GenServer.call(__MODULE__, :clear_state)
  end

  ## Callbacks ##

  def handle_call(:all, _from, state) do
    {:reply, state, state}
  end

  def handle_call(:all_grouped, _from, state) do
    groups =
      state
      |> Enum.map(&{&1.help_group, [&1]})
      |> Enum.reduce(%{}, &merge_groups/2)

    {:reply, {:ok, groups}, state}
  end

  def handle_call({:group, group}, _from, state) do
    functions =
      state
      |> Enum.filter(&(&1.help_group == group))

    {:reply, {:ok, functions}, state}
  end

  def handle_call(:group_names, _from, state) do
    names =
      state
      |> Enum.reduce(MapSet.new(), &MapSet.put(&2, &1.help_group))
      |> MapSet.to_list()

    {:reply, {:ok, names}, state}
  end

  def handle_call({:load_help, module}, _from, state) do
    entries = Help.to_help_entries(module)
    Logger.debug(fn -> "Loaded: module #{module}" end)

    {:reply, :ok, state ++ entries}
  end

  def handle_call(:clear_state, _from, _state) do
    {:reply, :ok, []}
  end

  def handle_call({:lookup, action}, _from, state) do
    return = 
      case Enum.find(state, &(&1.help_alias == action)) do
        nil -> {:error, "Not found"}
        help -> {:ok, help}
      end

    {:reply, return, state}
  end

  def handle_call({:lookup_multiple, functions}, _from, state) do
    help = Enum.filter(state, &(&1.help_alias in functions))

    {:reply, {:ok, help}, state}
  end

  defp merge_groups({group, fun}, acc) do
    Map.merge(acc, %{group => fun}, fn 
      _, v1, [v2] ->
      [v2 | v1]
    end)
  end
end
