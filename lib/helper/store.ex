defmodule Helper.Store do
  use GenServer

  require Logger

  def start_link(opts) do
    opts = Keyword.put(opts, :name, __MODULE__)
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  def init(:ok) do
    {:ok, %{}}
  end

  def load(module) do
    GenServer.call(__MODULE__, {:load_help, module})
  end

  def store(action, help) do
    with {:ok, ^action} <- GenServer.call(__MODULE__, {:store, action, help}) do
      Logger.debug(fn -> "Added: function #{action}" end)
      {:ok, action}
    else
      _error ->
        Logger.error(fn -> "Something went wrong" end)
    end
  end

  def all do
    GenServer.call(__MODULE__, :all)
  end

  def lookup(actions) when is_list(actions) do
    GenServer.call(__MODULE__, {:lookup_multiple, actions})
  end

  def lookup(action) do
    GenServer.call(__MODULE__, {:lookup, action})
  end

  ## Callbacks ##

  # def handle_call(:all, _from, state) do
  def handle_call(:all, _from, state) do
    {:reply, state, state}
  end

  def handle_call({:load_help, module}, _from, state) do
    Logger.debug(fn -> "Loaded: module #{module}" end)

    {:reply, :ok, merge(state, module)}
  end

  def handle_call({:lookup, action}, _from, state) do
    help = Map.get(state, action, "")

    {:reply, {:ok, help}, state}
  end

  def handle_call({:lookup_multiple, actions}, _from, state) do
    help = Map.take(state, actions)

    {:reply, {:ok, help}, state}
  end

  defp merge state, module do
    module
    |> help_from()
    |> Map.merge(state, fn _, _, v2 -> v2 end)
  end

  defp help_from module do
    Code.fetch_docs(module)
    |> functions
    |> Enum.map(&func_docs/1)
    |> Enum.reject(fn x -> x == nil end)
    |> Enum.into(%{})
  end

  defp functions({:docs_v1, _anno, :elixir, _format, _moduledoc, _meta, entries}) do
    entries
  end

  def func_docs({{:function, name, _arity}, _anno, _signature, _doc, %{help: help}}) do
    {name, help}
  end

  def func_docs(_), do: nil
end
