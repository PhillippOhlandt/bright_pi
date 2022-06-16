defmodule BrightPi.MixProject do
  use Mix.Project

  @version "1.0.0"

  def project do
    [
      app: :bright_pi,
      version: @version,
      name: "BrightPi",
      elixir: "~> 1.11",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      docs: docs(),
      source_url: "https://github.com/PhillippOhlandt/bright_pi",
      homepage_url: "https://github.com/PhillippOhlandt/bright_pi"
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:circuits_i2c, "~> 0.3.8 or ~> 1.0"},
      {:ex_doc, "~> 0.24", only: :dev, runtime: false},
      {:telemetry, "~> 1.0"}
    ]
  end

  defp docs do
    [
      main: "BrightPi",
      source_ref: @version,
      source_url: "https://github.com/PhillippOhlandt/bright_pi",
      extras: extras()
    ]
  end

  defp extras do
    [
      "CHANGELOG.md"
    ]
  end
end
