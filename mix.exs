defmodule Seek.Mixfile do
  use Mix.Project

  @version "0.0.1"

  def project do
    [app: :seek,
     description: "A simple wrapper around Postgrex to simplify writing SQL queries",
     version: @version,
     elixir: "~> 1.4",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     name: "Seek",
     package: package,
     docs: [source_ref: "v#{@version}",
       main: "readme",
       source_url: "https://github.com/amberbit/seek",
       extras: ["README.md"]],
     deps: deps()]
  end

  def package do
    [maintainers: ["Hubert Łępicki"],
      licenses: ["New BSD"],
      links: %{"GitHub" => "https://github.com/amberbit/seek"}]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    # Specify extra applications you'll use from Erlang/Elixir
    [extra_applications: [:logger, :postgrex, :deep_merge], mod: {Seek, []}]
  end

  # Dependencies can be Hex packages:
  #
  #   {:my_dep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:my_dep, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [{:postgrex, "~> 0.13.0"},
     {:ex_doc, "~> 0.14", only: :dev},
     {:deep_merge, "~> 0.1.0"} # TODO: get rid of this dep when have minute
    ]
  end
end
