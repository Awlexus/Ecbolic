# Ecobolic

A small library that should ease the implementation of a !help feature in chat bot

This library aims to provide a simple way of declaring and accessing 
documentations meant for users. This was build mainly to ease the implementation 
of the well-known `help` command, that many chat-bots provide.

## Usage

### Declaring 

The first step is to use the `Ecbolic` module in the module you want to
declare your documentations:

```elixir
defmodule TestModule do
  use Ecbolic
```

Then you can add document your functions like this:

```elixir
@doc help: "returns `:world`"

@doc """
It's thanks to the 1.7 elixir update that we can add meta data to the @doc annotation
"""
def hello, do: :world
```

At the start of your Application, or whenever you need it, you must load the documentation with with `load_help/0`

```elixir
Testmodule.load_help()
```


### Accessing
To access the documentations you can call the function `Ecbolic.help`, which comes in a variaty of forms:

  -  Ecbolic.help()
     Returns the documentation for all functions
  -  Ecbolic.help(functions)
     Returns the documentaion for the given functions 
  -  Ecbolic.help(fuction)
     Returns the documentation for the given function

#### Example

```elixir
Ecbolic.help(:hello)
#=> "returns `:world`"
```

### Formating

The module `Ecbolic.Pretty` provides some basic formating:

```
Ecbolic.Pretty.format(:hello)
#=> "hello - returns `world`"
```

You can provide your own format as a second parameter to `Ecbolic.Pretty.format/2`.
The default format is `":f - :h"`

Currently these are the tokens available for formating:

  - `:f` 
  
  Inserts the functions name
  - `:h` 
  
  Inserts the documentation
  - `:a` 
  
  If multiple entries are supplied, this token will align the strings, 
    by filling them with spaces, until they all end at the same position.

    Example:
    ```elixir
    Ecbolic.Pretty.format([:hello, :long_function_name], ":f:a - :h")
    #=> [
          "hello              - returns `world`",
          "long_function_name - Long description"
    ]
    ```

  Note: if the function is not found, it'll be ignored

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `ecbolic` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:ecbolic, "~> 0.2.3"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/ecbolic](https://hexdocs.pm/ecbolic).

