defmodule Mix.Enums do
  def generate_ecto_enums(nil) do
  end

  def generate_ecto_enums(enums) do
    paths = Mix.Phoenix.generator_paths()

    ecto_enum_path =
      Mix.Phoenix.context_app_path(
        :valiot_app,
        "lib/valiot_app/ecto_enums.ex"
      )

    Mix.Helper.copy_from(
      paths,
      "priv/templates/",
      [enums: enums],
      [
        {:eex, "ecto_enums.exs", ecto_enum_path}
      ],
      %{force: true}
    )
  end
end
