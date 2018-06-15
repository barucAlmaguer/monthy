defmodule Mix.GraphQL do
  def generate_resolvers(types) do
    paths = Mix.Phoenix.generator_paths()

    Enum.each(types, fn {k, v} ->
      ctx_path =
        Mix.Phoenix.context_app_path(
          :valiot_app,
          "lib/valiot_app/resolvers/#{Inflex.underscore(k)}_resolver.ex"
        )

      Mix.Helper.copy_from(
        paths,
        "priv/templates/",
        [k: k, v: v],
        [
          {:eex, "resolver.exs", ctx_path}
        ],
        %{force: true}
      )
    end)
  end

  def generate_types(%{types: types, enums: enums}) do
    paths = Mix.Phoenix.generator_paths()

    ctx_path =
      Mix.Phoenix.context_app_path(
        :valiot_app,
        "lib/valiot_app_web/schema/types.ex"
      )

    Mix.Helper.copy_from(
      paths,
      "priv/templates/",
      [enums: enums, types: types],
      [
        {:eex, "types.exs", ctx_path}
      ],
      %{force: true}
    )
  end

  def generate_schema(%{types: types, enums: enums}) do
    paths = Mix.Phoenix.generator_paths()

    ctx_path =
      Mix.Phoenix.context_app_path(
        :valiot_app,
        "lib/valiot_app_web/schema.ex"
      )

    Mix.Helper.copy_from(
      paths,
      "priv/templates/",
      [enums: enums, types: types],
      [
        {:eex, "graphql_schema.exs", ctx_path}
      ],
      %{force: true}
    )
  end
end
