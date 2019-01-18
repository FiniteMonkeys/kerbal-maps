defmodule KerbalMaps.MixProject do
  @moduledoc false

  use Mix.Project

  @default_version "0.1.0-default"

  def project do
    [
      app: :kerbal_maps,
      version: app_version(),
      elixir: "~> 1.7",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix, :gettext] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      preferred_cli_env: [espec: :test],
      aliases: aliases(),
      deps: deps()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {KerbalMaps.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "spec/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:credo, "~> 0.10.2", only: [:dev, :test], runtime: false},
      {:distillery, "~> 2.0"},
      {:ecto_sql, "~> 3.0"},
      {:espec_phoenix, "~> 0.6.10", only: :test},
      {:espec, "~> 1.6", only: :test},
      {:ex_machina, "~> 2.2", only: :test},
      {:faker, "~> 0.11.0", only: [:dev, :test], runtime: false},
      {:gettext, "~> 0.11"},
      {:jason, "~> 1.0"},
      {:mix_test_watch, "~> 0.9.0", only: :dev, runtime: false},
      {:nimble_parsec, "~> 0.5.0"},
      {:phoenix_ecto, "~> 4.0"},
      {:phoenix_html, "~> 2.11"},
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      {:phoenix_pubsub, "~> 1.1"},
      {:phoenix, "~> 1.4.0"},
      {:plug_cowboy, "~> 2.0"},
      {:postgrex, ">= 0.0.0"},
      {:pow, "~> 1.0"}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to create, migrate and run the seeds file at once:
  #
  #     $ mix ecto.setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.drop", "ecto.create --quiet", "ecto.migrate", "espec"]
    ]
  end

  ## Thanks to https://stackoverflow.com/a/52081108/688981 for the code on which the below is based,
  ## and https://minhajuddin.com/2017/01/18/a-simpler-way-to-generate-an-incrementing-version-for-elixir-apps/
  ## for clarification into how and why it works.

  # Build the version number from Git.
  # It will be something like 1.0.0-beta1 when built against a tag, and
  # 1.0.0-beta1+18.ga9f2f1ee when built against something after a tag.
  defp app_version do
    with {:ok, string} <- get_git_version(),
         [_, version, commit] <- Regex.run(~r/([\d\.]+(?:\-[a-zA-Z]+\d*)?)(.*)/, String.trim(string)) do
      version <> "-" <> (commit |> String.replace(~r/^-/, "") |> String.replace(~r/-.*$/, ""))
    else
      other ->
        IO.puts("Could not get version. error: #{other}")
        @default_version
    end
  end

  # Put a version string in `VERSION` to override any tags in git.
  defp get_git_version do
    case File.read("VERSION") do
      {:error, _} ->
        case System.cmd("git", ["describe"]) do
          {string, 0} -> {:ok, string}
          {error, errno} -> {:error, "Could not get version. errno: #{inspect errno}, error: #{inspect error}"}
        end
      ok -> ok
    end
  end
end
