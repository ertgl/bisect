defmodule Bisect.Mixfile do
  use Mix.Project

  @version "0.2.0"

  @description """
  Bisection algorithms.
  """

  @source_url "https://github.com/ertgl/bisect"

  def version() do
    @version
  end

  def description() do
    @description
  end

  def source_url() do
    @source_url
  end

  def project do
    [
      app: :bisect,
      version: version(),
      description: description(),
      source_url: source_url(),
      package: package(),
      docs: docs(),
      preferred_cli_env: preferred_cli_env(),
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application() do
    [
      extra_applications: [
        :logger
      ]
    ]
  end

  def package() do
    [
      maintainers: [
        "Ertuğrul Noyan Keremoğlu <ertugkeremoglu@gmail.com>"
      ],
      licenses: [
        "MIT"
      ],
      links: %{
        "GitHub" => source_url()
      },
      files: [
        "lib",
        "mix.exs",
        "README.md",
        ".formatter.exs"
      ]
    ]
  end

  def docs() do
    [
      name: "Bisect",
      main: "Bisect",
      source_url: source_url(),
      source_ref: "v#{@version}",
      formatters: [
        "html",
        "epub"
      ]
    ]
  end

  def preferred_cli_env() do
    [
      docs: :docs
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps() do
    [
      {:ex_doc, "~> 0.22.1", optional: true, only: :docs}
    ]
  end
end
