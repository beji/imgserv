defmodule ImgservWeb.MixProject do
  use Mix.Project

  def project do
    [
      app: :imgserv_web,
      version: "0.1.0",
      elixir: "~> 1.7",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {ImgservWeb.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"},
      # {:swarm, "~> 3.3"},
      # {:libcluster, "~> 3.0"},
      {:plug, "~> 1.6"},
      {:cowboy, "~> 2.4"},
      {:redix, "~> 0.8.1"},
      {:poolboy, "~> 1.5"},
      # {:peerage, "~> 1.0"},
      {:libcluster, "~> 3.0"},
      {:poison, "~> 4.0"},
      {:cors_plug, "~> 1.5"},
      {:mock, "~> 0.3.2", only: [:test]}
    ]
  end
end
