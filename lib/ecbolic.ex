defmodule Ecbolic do
  @moduledoc """
  This module aims to provide a simple interface to 
  `Ecbolic.Store` and the neccessary tools to add 
  documentation to functions, which is easly accessable
  at runtime. This library was build with the intend to
  make it easy to show help for users of applications, 
  such as chat bots.

  In order to start creating documentation you first need 
  to use this module

  ```elixir
  defmodule TestModule do
    use Ecbolic
  ```

  Then you can start adding your documentation like using
  the macro `Ecbolic.help/1`. Modules without macro call above
  them will be ignored

  ```elixir
  Ecbolic.help("returns `:world`")
  def hello, do: :world
  ```

  In order to access the entries, you first have to load them.
  The function `load_help()` will be added when you use 
  `Ecbolic` in your module. Calling this function will load
  the documentation you created into `Ecbolic.Store`, where 
  it can be accessed from anywhere.

  ```elixir
  TestModule.load_help()
  ```

  Under the hood this macro (ab)uses a feature added to 
  Elixir 1.7, which allows you to add meta data to your 
  documentation. So the snippet above will turn out like
  this:

  ```elixir
  @doc help: "returns `:world`"
  def hello, do: :world
  ```

  Both forms are valid to use, but you should stick with
  macro, so that it'll continue to work, when the an other
  key will be used.

  By default functions are stored with their function names.
  So the function `hello` will be turned into `:hello`. In case 
  you want your function to be named by a different name, you 
  can do so, by aliasing it with `Ecbolix.alias/1`.
  The internal function name will then be replaced with 
  whatever you provide here. Even though, I suggest to restrain 
  yourself to only use names, which can be turned into a string,
  such as string as atom. Things that cannot be turned into 
  Strings will cause `Ecbolic.Pretty` problems when formatting
  the entries.

  ```
  Ecbolic.help("returns `:world`")
  Ecbolic.alias("Hello world") # Allows for spaces
  def hello, do: :world
  ```
  You can also group all functions within a module with the
  macro `Ecbolic.group/1`. 

  ```elixir
  Ecbolic.group("memes")
  def hello_there, do: "General Kenobi"
  ```

  Ungrouped functions, will be grouped with `:default`
  by default.

  """
  @type atom_or_string :: atom | String.t
  alias Ecbolic.{Store, Help}

  defmacro __using__(_opts) do
    quote do
      require Ecbolic

      def load_help do
        Ecbolic.Store.load(__MODULE__)
      end
    end
  end

  @doc """
  Returns all help entries as a map, where each function
  is mapped it's documentation
  """
  @spec fetch_help() :: %{atom_or_string => String.t()}
  def fetch_help do
    Store.all()
    |> Enum.map(fn %Help{help_alias: name, help: help} -> {name, help} end)
    |> Enum.into(%{})
  end

  @doc """
  Returns all requested help entries as a map, where each 
  function is mapped it's documentation
  Will return an empty map, in none was found
  """   
  @spec fetch_help([atom_or_string]) :: %{atom_or_string => String.t()}
  def fetch_help(names) when is_list(names) do
    with {:ok, help_entries} <- Store.lookup(names) do
      help_entries
      |> Enum.map(&{&1.help_alias, &1.help})
      |> Enum.into(%{})
    end
  end

  @doc """
  Returns the documentation for the one requested function. 
  Will return nil, if it was not found
  """
  @spec fetch_help(atom_or_string) :: String.t()
  def fetch_help(name) do
    with {:ok, help_entry} <- Store.lookup(name),
         %Help{help: help} <- help_entry do
      help
    else
      {:error, _reason} ->
        nil
    end
  end

  @doc """
  Returns all functions in the given group, mapped to their
  documentation
  """
  @spec help_group(atom_or_string) :: %{atom_or_string => String.t}
  def help_group(group_name) do
    with {:ok, group} <- Store.group(group_name) do
      group
      |> Enum.map(&{&1.help_alias, &1.help})
      |> Enum.into(%{})
    end
  end

  @doc """
  Aliases the name by with the documentation for a functions
  is accessed
  """
  defmacro alias name do
    func_attr(:help_alias, name)
  end

  @doc """
  Sets the group for all functions in that module
  """
  defmacro group(group) do
     func_attr(:help_group, group)
  end

  @doc """
  Creates a documentation for the function below
  """
  defmacro help(help) do
    func_attr(:help, help)
  end

  defp func_attr(attr, val) do
    quote do
      @doc [unquote({attr, val})]
    end
  end
end
