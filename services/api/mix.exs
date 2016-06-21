defmodule Pipelite.Mixfile do
  use Mix.Project

  def project do
    [
      app: :pipelite,
      version: "0.0.1",
      elixir: "~> 1.2.0",
      elixirc_paths: elixirc_paths(Mix.env),
      compilers: [:phoenix, :gettext] ++ Mix.compilers,
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      deps: deps,
    ]
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    [
      mod: {Pipelite, []},
      applications: applications(Mix.env),
    ]
  end

  defp applications(_), do: applications
  defp applications do
    [
      :cowboy,
      :exsentry,
      :gettext,
      :httpoison,
      :logger,
      :phoenix,
      :phoenix_ecto,
      :phoenix_html,
      :postgrex,
      :tirexs,
      :tzdata
    ]
  end

  # Specifies which paths to compile per environment
  defp elixirc_paths(:test), do: ["lib", "web", "test/support"]
  defp elixirc_paths(_), do: ["lib", "web"]

  # Specifies your project dependencies
  #
  # Type `mix help deps` for examples and options
  defp deps do
    [
      {:cowboy, "~> 1.0"},
      {:credo, "~> 0.3", only: [:dev, :test]},
      {:exsentry, "~> 0.3.0"},
      {:gettext, "~> 0.10"},
      {:httpoison, "~> 0.7"},
      {:phoenix, "~> 1.1.4"},
      {:phoenix_ecto, "~> 2.0"},
      {:phoenix_html, "~> 2.3"},
      {:phoenix_live_reload, "~> 1.0"},
      {:poolboy, "~> 1.5.1"},
      {:postgrex, "~> 0.11.0"},
      {:scrivener, "~> 1.0"},
      {:timex, "~> 2.1.4"},
      {:tirexs, "~> 0.7.6"},
   ]
  end
end
