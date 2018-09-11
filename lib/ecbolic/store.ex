defmodule Ecbolic.Store do
  use GenServer

  require Logger

  alias Ecbolic.Help

  def start_link(opts) do
    opts = Keyword.put(opts, :name, __MODULE__)
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  def init(:ok) do
    {:ok, []}
  end

  def load(module) do
    GenServer.call(__MODULE__, {:load_help, module})
  end

  def all do
    GenServer.call(__MODULE__, :all)
  end

  def all_grouped do
    GenServer.call(__MODULE__, :all_grouped)
  end

  def lookup(actions) when is_list(actions) do
    GenServer.call(__MODULE__, {:lookup_multiple, actions})
  end

  def lookup(action) do
    GenServer.call(__MODULE__, {:lookup, action})
  end

  def group(group) do
    GenServer.call(__MODULE__, {:group, group})
  end

  def group_names do
    GenServer.call(__MODULE__, :group_names)
  end

  ## Callbacks ##

  def handle_call(:all, _from, state) do
    {:reply, state, state}
  end

  def handle_call(:all_grouped, _from, state) do
    groups =
      state
      |> Stream.map(&{&1.help_group, [&1]})
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

  def handle_call({:lookup, action}, _from, state) do
    return = 
      case Enum.find(state, &(&1.help_alias == action)) do
        nil -> {:error, "Not found"}
        help -> {:ok, help}
      end

    {:reply, return, state}
  end

  def handle_call({:lookup_multiple, actions}, _from, state) do
    help = Enum.filter(state, &(&1.help_alias in actions))

    {:reply, {:ok, help}, state}
  end

  defp merge_groups({group, fun}, acc) do
    Map.merge(acc, %{group => fun}, fn 
      _, v1, [v2] ->
      [v2 | v1]
    end)
  end
end
