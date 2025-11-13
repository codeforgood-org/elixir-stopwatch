defmodule Stopwatch.MixProject do
  use Mix.Project

  @version "1.0.0"
  @source_url "https://github.com/codeforgood-org/elixir-stopwatch"

  def project do
    [
      app: :stopwatch,
      version: @version,
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      escript: escript(),

      # Docs
      name: "Stopwatch",
      description: "A feature-rich command-line stopwatch with lap timing and multiple timer support",
      source_url: @source_url,
      docs: docs(),
      package: package()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:ex_doc, "~> 0.31", only: :dev, runtime: false}
    ]
  end

  defp escript do
    [
      main_module: Stopwatch.CLI
    ]
  end

  defp docs do
    [
      main: "readme",
      extras: ["README.md", "CHANGELOG.md"],
      source_ref: "v#{@version}",
      source_url: @source_url
    ]
  end

  defp package do
    [
      licenses: ["MIT"],
      links: %{"GitHub" => @source_url},
      maintainers: ["codeforgood-org"]
    ]
  end
end
