# Helper

A small library to @help your users. 

This library aims to provide a simple way of declaring and accessing 
documentations meant for users. This was build mainly to ease the implementation 
of the well-known `help` command, that many chat-bots provide.

## Usage

### Declaring 

The first step is to use the `Helper` module in the module you want to
declare your documentations:

```elixir
defmodule TestModule do
  use Helper
```

Then you can add document your functions like this:

```elixir
  @doc help: "returns `:world`"

  @doc """
  It's thanks to the 1.7 elixir update you can add meta data with your docs
  """
  def hello, do: :world
```

At the start of your Application, or whenever you need it, you must load the documentation with with `load_help/0`

```elixir
Testmodule.load_help()
```


### Accessing
To access the documentations you can call the function `Helper.help`, which comes in a variaty of forms:

  -  Helper.help()
     Returns the documentation for all functions
  -  Helper.help(functions)
     Returns the documentaion for the given functions 
  -  Helper.help(fuction)
     Returns the documentation for the given function

#### Example

```elixir
  iex> Helper.help(TestModule, :hello)
  "returns `:world`"
```

### Formating

The module `Helper.Pretty` provides some basic formating:

```
  iex(1)> Helper.Pretty.format(:hello)
  "hello - returns `world`"
```

You can provide your own format as a second parameter to `Helper.Pretty.format/2`.
The default format is `":f - :h"`

Currently these are the tokens available for formating:

  - :f
    Inserts the functions name
  - :h
    Inserts the documentation
  - :a
    If multiple entries are supplied, this token will align the strings, 
    by filling them with spaces, until they all end at the same position.

    Example:
    ```elixir
      iex(1)> Helper.Pretty.format([:hello, :long_function_name]":f:a - :h")
      [
      	"hello              - returns `world`",
	"long_function_name - Long description"
      ]
    ```

    Note: if the function is not found, it'll be ignored

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `helper` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:helper, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/helper](https://hexdocs.pm/helper).

