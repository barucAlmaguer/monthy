defmodule Mix.Schema do
  def generate_schemas(types) do
    paths = Mix.Phoenix.generator_paths()

    Enum.each(types, fn {k, v} ->
      ctx_path =
        Mix.Phoenix.context_app_path(
          :valiot_app,
          "lib/valiot_app/api/#{k |> Inflex.underscore()}.ex"
        )

      Mix.Helper.copy_from(
        paths,
        "priv/templates/",
        [k: k, v: v],
        [
          {:eex, "schema.exs", ctx_path}
        ],
        %{force: true}
      )
    end)
  end

  def generate_context(types) do
    paths = Mix.Phoenix.generator_paths()

    ctx_path =
      Mix.Phoenix.context_app_path(
        :valiot_app,
        "lib/valiot_app/api/api.ex"
      )

    Mix.Helper.copy_from(
      paths,
      "priv/templates/",
      [types: types],
      [
        {:eex, "api.exs", ctx_path}
      ],
      %{force: true}
    )
  end
end
