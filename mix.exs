defmodule Helper.MixProject do
  use Mix.Project

  def project do
    [
      app: :ecbolic,
      version: "0.2.1",
      elixir: "~> 1.7",
      elixirc_paths: elixirc_paths(Mix.env),
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: description(),
      package: package(),
      name: "Ecbolic",
      source_url: "https://github.com/awlexus/ecbolic"
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Ecbolic.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ex_doc, ">= 0.0.0", only: :dev}
    ]
  end

  defp description do
    "A simple library that should help you simplify implementing a help command for your Chat bot"
  end

  defp package do
    [
      name: "ecbolic",
      files: ~w(lib mix.exs README.md config LICENSE),
      licenses: ["Apache 2.0"],
      links: %{"Github" => "https://github.com/Awlexus/ecbolic"}
    ]
  end

  defp elixirc_paths :test do
    ["lib", "test/test_modules"]
  end

  defp elixirc_paths _ do
    ["lib"]
  end
end
