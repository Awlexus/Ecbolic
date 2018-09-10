defmodule Ecbolic.Help do
  @module_attributes [:help_group]
  @function_attributes [:help, :help_alias]

  alias Ecbolic.Help
  # [help_group: :default, help_alias: nil, help: nil]
  defstruct help_group: :default, help: nil, help_alias: nil
  @type t :: %Help{help_group: atom, help: atom, help: String.t()}

  def to_help_entries(module) do
    with {:docs_v1, _anno, :elixir, _format, _module_doc, meta, docs} <- Code.fetch_docs(module) do
      mattributes = module_attributes(meta)
      fattributes = function_attributes(docs)

      base_entry = Map.merge(%Help{}, mattributes)

      Enum.map(fattributes, fn fattribute ->
        Map.merge(base_entry, fattribute)
      end)
    end
  end

  defp module_attributes(:none), do: %{}
  defp module_attributes(:hidden), do: %{}

  defp module_attributes(doc) do
    doc
    |> Map.take(@module_attributes)
  end

  defp function_attributes(docs) do
    docs
    |> Enum.reduce([], &function/2)
    |> Enum.map(&Map.take(&1, @function_attributes))
  end

  defp function(doc, acc) do
    case doc do
      {_, _, _, _, %{help: _, help_alias: _} = meta} -> [meta | acc]
      {{_, name, _}, _, _, _, %{help: _} = meta} -> [Map.merge(meta, %{help_alias: name}) | acc]
      _ -> acc
    end
  end
end
