defmodule Cake.Service.Mixfile do
    use Mix.Project

    def project do
        [
            app: :cake_service,
            version: "0.1.0",
            build_path: "../../_build",
            config_path: "../../config/config.exs",
            deps_path: "../../deps",
            lockfile: "../../mix.lock",
            elixir: "~> 1.5",
            build_embedded: Mix.env == :prod,
            start_permanent: Mix.env == :prod,
            deps: deps(Mix.Project.umbrella?)
        ]
    end

    # Configuration for the OTP application
    #
    # Type "mix help compile.app" for more information
    def application do
        [
            mod: { Cake.Service, [] },
            extra_applications: [:logger]
        ]
    end

    # Dependencies can be Hex packages:
    #
    #   {:my_dep, "~> 0.3.0"}
    #
    # Or git/path repositories:
    #
    #   {:my_dep, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
    #
    # To depend on another app inside the umbrella:
    #
    #   {:my_app, in_umbrella: true}
    #
    # Type "mix help deps" for more examples and options
    defp deps(false), do: deps(true) ++ [{ :cake_email, path: "../cake_email" }]
    defp deps(true), do: [{ :swoosh, "~> 0.13.0" }]
end
