defmodule Bisect.Mixfile do

	use Mix.Project

	def project() do
		[
			name: "Bisect",
			source_url: "https://github.com/ertgl/bisect",
			description: description(),
			package: package(),
			app: :bisect,
			version: "0.1.0",
			elixir: "~> 1.5",
			start_permanent: Mix.env() == :prod,
			deps: deps(),
			docs: [
				main: "Bisect",
			],
		]
	end

	def description() do
		"""
		Bisection algorithms ported from Python.
		"""
	end

	def package() do
		[
			name: :bisect,
			files: [
				"lib",
				"mix.exs",
				"README.md",
				"LICENSE.txt",
			],
			maintainers: [
				"Ertugrul Keremoglu <ertugkeremoglu@gmail.com>",
			],
			licenses: [
				"MIT",
			],
			links: %{
				"GitHub" => "https://github.com/ertgl/bisect",
			},
		]
	end

	# Run "mix help compile.app" to learn about applications.
	def application() do
		[
			extra_applications: [
				:logger,
			],
		]
	end

	# Run "mix help deps" to learn about dependencies.
	defp deps() do
		[
			{:ex_doc, "~> 0.16", only: :dev, runtime: false},
		]
	end

end
