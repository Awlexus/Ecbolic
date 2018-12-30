defmodule Ecbolic.Pretty do
  @moduledoc """
  This module provides small formating for when you want
  to display your docs.

  All functions intended for formating can be supplied
  with a string, which allows you to use function names,
  help and such. The default format is `":f - :h`

  - :f

  Inserts the name function of the function

  - :h

  Inserts the documentation of the function

  - :u

  Inserts the usage of a function

  - :a

  Aligns all documentations up to this point. This only
  works with functions that format multiple functions.

  ## Example output

  ```elixir
  Ecbolic.Pretty.format([:hello, :long_function_name], ":f:a - :h")
  #=>
  "hello              - returns `world`",
  "long_function_name - Long description"
  ```
  """
  alias Ecbolic.{Store, Help}

  @doc """
  Formats all functions according to the given format
  """
  @spec format_all(String.t()) :: String.t()
  def format_all(format \\ ":f - :h") do
    Store.all()
    |> format_entries(format)
  end

  @doc """
  Formats all functions according to the given format,
  but clustered by their group.
  """
  @spec format_all_groups(String.t()) :: %{Ecbolic.atom_or_string() => String.t()}
  def format_all_groups(format \\ ":f - :h") do
    {:ok, groups} = Store.all_grouped()
    for {k, v} <- groups, into: %{}, do: {k, format_entries(v, format)}
  end

  @doc """
  Formats all functions that belong to the given group
  """
  @spec format_group(Ecbolic.atom_or_string(), String.t()) :: String.t()
  def format_group(group, format \\ ":f - :h") do
    with {:ok, entries} <- Store.group(group) do
      format_entries(entries, format)
    end
  end

  @doc """
  Formats a single or multiple given functions
  """
  def format(list, format \\ ":f - :h")

  def format([], _), do: []

  def format(nil, _), do: []

  @spec format([Ecbolic.atom_or_string()], String.t()) :: String.t()
  def format(names, format) when is_list(names) do
    with {:ok, entries} <- Store.lookup(names) do
      format_entries(entries, format)
    end
  end

  @spec format(Ecbolic.atom_or_string(), String.t()) :: String.t()
  def format(name, format) do
    with {:ok, help} <- Store.lookup(name) do
      apply_tokens(help, format)
      |> String.replace(":a", "")
    end
  end

  @doc """
  Aligns multiple strings using tokens

  This function adds spaces where the tokens are places, 
  so that the Strings before the token are aligned

    ## Examples

      iex>Ecbolic.Pretty.align [ 
      ...>  "aaaaaaaaaa :a - 100.00:a%", 
      ...>  "aaaaaaaaa :a - 20.50:a%", 
      ...>  "aaaaaaaa :a - 19.53:a%", 
      ...>  "aaaaaaa :a - 17.42:a%", 
      ...>  "aaaaaa :a - 17.29:a%", 
      ...>  "aaaaa :a - 16.48:a%", 
      ...>  "aaaa :a - 15.75:a%", 
      ...>  "aaa :a - 15.10:a%" 
      ...>]
      [ 
        "aaaaaaaaaa  - 100.00%", 
        "aaaaaaaaa   - 20.50 %", 
        "aaaaaaaa    - 19.53 %", 
        "aaaaaaa     - 17.42 %", 
        "aaaaaa      - 17.29 %", 
        "aaaaa       - 16.48 %", 
        "aaaa        - 15.75 %", 
        "aaa         - 15.10 %" 
      ]

  """
  @spec align([String.t()]) :: [String.t()]
  def align([]), do: []

  def align(entries) do
    {to_split, rejected} =
      entries
      |> Enum.split_with(&String.contains?(&1, ":a"))

    split =
      to_split
      |> Enum.map(&String.split(&1, ":a", parts: 2))

    if Enum.empty?(split) do
      entries
    else
      # Transposing
      [to_align, rest] = transpose(split)

      max_length =
        to_align
        |> Enum.map(&String.length/1)
        |> Enum.max()

      aligned =
        to_align
        |> Enum.map(&(&1 <> String.duplicate(" ", max_length - String.length(&1))))

      new_entries =
        [aligned, rest]
        |> transpose()
        |> Enum.map(&Enum.join/1)

      rejected ++ align(new_entries)
    end
  end

  defp format_entries(entries, format) do
    entries
    |> Enum.map(&apply_tokens(&1, format))
    |> align()
    |> Enum.sort(&lexographical_compare/2)
    |> Enum.join("\n")
  end

  @doc false
  def lexographical_compare("", _), do: false
  def lexographical_compare(_, ""), do: true

  def lexographical_compare(str1, str2) do
    {f1, r1} = String.split_at(str1, 1)
    {f2, r2} = String.split_at(str2, 1)

    cond do
      f1 == f2 -> lexographical_compare(r1, r2)
      String.downcase(f1) == String.downcase(f2) and f1 > f2 -> true
      String.downcase(f1) == String.downcase(f2) -> false
      String.downcase(f1) > String.downcase(f2) -> false
      true -> true
    end
  end

  defp apply_tokens(help, format) do
    format
    |> String.replace(":f", to_string(help.name))
    |> String.replace(":g", to_string(help.group))
    |> String.replace(":u", help.usage || "")
    |> String.replace(":h", help.description || "")
  end

  defp transpose(list) do
    list
    |> List.zip()
    |> Enum.map(&Tuple.to_list/1)
  end
end
