defmodule BrightPi.MixProject do
  use Mix.Project

  def project do
    [
      app: :bright_pi,
      version: "0.1.0",
      elixir: "~> 1.11",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      name: "BrightPi",
      source_url: "https://github.com/PhillippOhlandt/bright_pi",
      homepage_url: "https://github.com/PhillippOhlandt/bright_pi",
      docs: [
        main: "BrightPi"
      ]
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
end
