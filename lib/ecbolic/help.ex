defmodule Ecbolic.Help do
  alias Ecbolic.Help

  defstruct help_group: :default, help: nil, help_alias: nil
  @type t :: %Help{help_group: atom, help: atom, help_alias: String.t()}

  @doc """
  Goes through the documentation of a module, parses it's meta
  data and returns returns the a Help struct for each function 
  with matching attributes

  See `Ecbolic` information on how to add helping meta data to
  a function
  """
  @spec to_help_entries(atom) :: [Help.t()]
  def to_help_entries(module) do
    {:docs_v1, _anno, :elixir, _format, _meta, module_doc, docs} = Code.fetch_docs(module)

    docs
    |> Enum.reduce([], &meta_data/2)
    |> Enum.map(&add_group(&1, module_doc))
    |> Enum.map(&struct(Help, &1))
  end

  defp meta_data(doc, acc) do
    case doc do
      {_, _, _, _, %{help: _, help_alias: _} = meta} -> [meta | acc]
      {{_, name, _}, _, _, _, %{help: _} = meta} -> [Map.merge(meta, %{help_alias: name}) | acc]
      _ -> acc
    end
  end

  defp add_group(meta, %{help_group: group}) do
    Map.put(meta, :help_group, group)
  end

  defp add_group(meta, _) do
    meta
  end
end
