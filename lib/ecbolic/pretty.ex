defmodule Ecbolic.Pretty do
  alias Ecbolic.Store

  def format_all(format \\ ":f - :h") do
    Store.all()
    |> format_entries(format)
  end

  def format_all_groups(format \\ ":f - :h") do
    {:ok, groups} = Store.all_grouped()
    for {k, v} <- groups, into: %{}, do: {k, format_entries(v, format)}
  end

  def format_group(group, format \\ ":f - :h") do
    with {:ok, entries} <- Store.group(group) do
      format_entries(entries, format)
    end
  end

  def format(list, format \\ ":f - :h")

  def format([], _), do: []

  def format(nil, _), do: []

  def format(names, format) when is_list(names) do
    with {:ok, entries} <- Store.lookup(names) do
      format_entries(entries, format)
    end
  end

  def format(name, format) do
    help = Ecbolic.help(name)

    apply_tokens({name, help}, format)
    |> String.replace(":a", "")
  end

  defp align([]), do: []

  defp align(entries) do
    split = Enum.map(entries, &String.split(&1, ":a", parts: 2))

    unless split |> List.flatten() |> Enum.count() == 2 * Enum.count(entries) do
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

      align(new_entries)
    end
  end

  defp format_entries(entries, format) do
    entries
    |> Enum.map(&{&1.help_alias, &1.help})
    |> Enum.map(&apply_tokens(&1, format))
    |> align()
    |> Enum.sort(&lexographical_compare/2)
    |> Enum.join("\n")
  end

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

  defp apply_tokens({name, help}, format) do
    format
    |> String.replace(":f", Atom.to_string(name))
    |> String.replace(":h", help)
  end

  defp transpose(list) do
    list
    |> List.zip()
    |> Enum.map(&Tuple.to_list/1)
  end

end
