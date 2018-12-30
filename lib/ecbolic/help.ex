defmodule Ecbolic.Help do
  alias Ecbolic.Help

  @moduledoc """
  Stores information about a Function related to help
  """

  defstruct group: :default, description: nil, name: nil, usage: nil

  @type atom_or_string :: atom | String.t()
  @type t :: %Help{
          group: atom_or_string,
          name: atom_or_string,
          description: String.t(),
          usage: String.t()
        }

  @doc """
  Goes through the documentation of a module, parses it's meta
  data and returns returns the a Help struct for each function 
  with matching attributes

  See `Ecbolic` information on how to add helping meta data to
  a function
  """
  @spec to_help_entries(module) :: [Help.t()]
  def to_help_entries(module) do
    {:docs_v1, _anno, :elixir, _format, _meta, module_doc, docs} = Code.fetch_docs(module)

    docs
    |> Stream.filter(&has_help?/1)
    |> Stream.map(&meta_data/1)
    |> Stream.map(&add_group(&1, module_doc))
    |> Stream.map(&to_keymap/1)
    |> Stream.map(&struct(Help, &1))
    |> Enum.into([])
  end

  defp has_help?({_, _, _, _, %{help_description: _}}) do
    true
  end

  defp has_help?(_) do
    false
  end

  defp meta_data(doc) do
    case doc do
      {_, _, _, _, %{help_description: _, help_alias: _} = meta} ->
        meta

      {{_, name, _}, _, _, _, %{help_description: _} = meta} ->
        Map.put(meta, :help_alias, name)
    end
  end

  defp add_group(meta, %{help_group: group}) do
    Map.put(meta, :help_group, group)
  end

  defp add_group(meta, _) do
    meta
  end

  defp to_keymap(map) do
    Enum.reduce(map, %{}, fn
      {:help_alias, name}, acc -> Map.put(acc, :name, name)
      {:help_usage, usage}, acc -> Map.put(acc, :usage, usage)
      {:help_description, description}, acc -> Map.put(acc, :description, description)
      {:help_group, group}, acc -> Map.put(acc, :group, group)
      _, acc -> acc
    end)
  end
end
