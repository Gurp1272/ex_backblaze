defmodule ExBackblaze.MixProject do
  use Mix.Project

  def project do
    [
      app: :ex_backblaze,
      version: "0.1.0",
      elixir: "~> 1.14",
      description: "Backblaze API wrapper for Elixir",
      source_url: "https://github.com/Gurp1272/ex_backblaze",
      homepage_url: "https://github.com/Gurp1272/ex_backblaze",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {ExBackblaze.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:finch, "~> 0.14"},
      {:jason, "~> 1.4"},
      {:ex_doc, "~> 0.29.2", only: :dev, runtime: false}
    ]
  end

  defp package() do
    [
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/Gurp1272/ex_backblaze"}
    ]
  end
end
