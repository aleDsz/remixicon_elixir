defmodule Mix.Tasks.Remixicon.Build do
  # Builds a new lib/remixicons.ex with bundled icon set.
  @moduledoc false
  @shortdoc false
  use Mix.Task

  alias Mix.Tasks.Remixicon.Update, as: UpdateTask

  @target_file "lib/remixicons.ex"

  def run(_args) do
    vsn = UpdateTask.vsn()
    svgs_path = UpdateTask.svgs_path()
    line = Path.wildcard(Path.join(svgs_path, "line/**/*.svg"))
    fill = Path.wildcard(Path.join(svgs_path, "fill/**/*.svg"))
    ordered_icons = line ++ fill

    icons =
      Enum.group_by(ordered_icons, &function_name(&1), fn file ->
        for path <- file |> File.read!() |> String.split("\n"),
            path = String.trim(path),
            String.starts_with?(path, "<path"),
            do: path
      end)

    Mix.Generator.copy_template("assets/remixicons.exs", @target_file, %{icons: icons, vsn: vsn},
      force: true
    )

    Mix.Task.run("format")
  end

  defp function_name(file) do
    file
    |> Path.basename()
    |> Path.rootname()
    |> String.split("-")
    |> Enum.join("_")
  end

  def normalize_function_name(file) do
    name = function_name(file)
    if Regex.match?(~r/^[0-9]/, name), do: "i" <> name, else: name
  end
end
