defmodule Mix.Schema do
  def generate_context(types) do
    paths = Mix.Phoenix.generator_paths()

    ctx_path =
      Mix.Phoenix.context_app_path(
        :valiot_app,
        "lib/valiot_app/api/api.ex"
      )

    Mix.Phoenix.copy_from(paths, "priv/templates/", [types: types], [
      {:eex, "api.exs", ctx_path}
    ])
  end
end
