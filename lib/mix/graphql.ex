defmodule Mix.GraphQL do
  def generate_resolvers(types) do
    paths = Mix.Phoenix.generator_paths()

    Enum.each(types, fn {k, v} ->
      ctx_path =
        Mix.Phoenix.context_app_path(
          :valiot_app,
          "lib/valiot_app/resolvers/#{Inflex.underscore(k)}_resolver.ex"
        )

      Mix.Phoenix.copy_from(paths, "priv/templates/", [k: k, v: v], [
        {:eex, "resolver.exs", ctx_path}
      ])
    end)
  end
end
