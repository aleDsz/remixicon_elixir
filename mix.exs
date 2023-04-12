defmodule RemixiconsElixir.MixProject do
  use Mix.Project

  @version "0.1.0"
  @source_url "https://github.com/aleDsz/remixicons_elixir"

  def project do
    [
      app: :remixicons,
      version: @version,
      elixir: "~> 1.11",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      name: "Remixicons",
      source_url: @source_url,
      description: "Phoenix components for Remixicons!",
      docs: docs(),
      package: package(),
      xref: [exclude: [:httpc, :public_key]]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:phoenix_live_view, "~> 0.18.2"},
      {:ex_doc, "~> 0.23", only: :dev, runtime: false},
      {:castore, ">= 0.0.0"}
    ]
  end

  defp package do
    [
      licenses: ["Apache License 2.0"],
      links: %{"GitHub" => @source_url}
    ]
  end

  defp docs do
    []
  end
end
