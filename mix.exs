defmodule ElixlsxView.MixProject do
  use Mix.Project

  @version "0.1.0"

  def project do
    [
      app: :elixlsx_view,
      version: @version,
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      deps: deps(),

      # Docs
      name: "ElixlsxView",
      docs: docs(),

      # Hex
      description: description(),
      package: package()
    ]
  end

  def application do
    []
  end

  defp deps do
    [
      {:elixlsx, "~> 0.4"},
      {:ex_doc, "~> 0.14", only: :dev, runtime: false}
    ]
  end

  defp docs do
    [
      main: "ElixlsxView",
      extras: ["README.md"],
      source_url: "https://github.com/Elonsoft/elixlsx_view"
    ]
  end

  defp description do
    "This library is used to render data as xlsx documents in phoenix views."
  end

  defp package do
    [
      links: %{"GitHub" => "https://github.com/Elonsoft/elixlsx_view"},
      licenses: ["MIT"],
      files: ~w(mix.exs README.md LICENSE.md lib)
    ]
  end
end
