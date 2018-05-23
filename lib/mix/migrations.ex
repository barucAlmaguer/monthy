defmodule Mix.Migrations do
  def generate_migrations(types) do
    paths = Mix.Phoenix.generator_paths()

    Enum.each(types, fn {k, v} ->
      ctx_path =
        Mix.Phoenix.context_app_path(
          :valiot_app,
          "priv/repo/migrations/#{timestamp()}_create_#{k |> Inflex.underscore() |> Inflex.pluralize()}.exs"
        )

      :timer.sleep(1000)

      Mix.Phoenix.copy_from(paths, "priv/templates/", [k: k, v: v], [
        {:eex, "migration.exs", ctx_path}
      ])
    end)
  end

  defp timestamp do
    {{y, m, d}, {hh, mm, ss}} = :calendar.universal_time()
    "#{y}#{pad(m)}#{pad(d)}#{pad(hh)}#{pad(mm)}#{pad(ss)}"
  end

  defp pad(i) when i < 10, do: <<?0, ?0 + i>>
  defp pad(i), do: to_string(i)
end
