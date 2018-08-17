defmodule Mix.Tasks.Valiot.Gen.Api do
  use Mix.Task

  alias ValiotApp.SdlProcessing

  def run(args) do
    [path] = args

    case File.read(path) do
      {:ok, body} ->
        SdlProcessing.start_processing(body)
        |> createFiles

      {:error, reason} ->
        IO.puts("There was an error when opening the file ): Reason: #{reason}")
    end
  end

  defp createFiles({:error, error}) do
    IO.inspect(error)
  end

  defp createFiles({:ok, struct}) do
    struct = Mix.Permissions.generate_perms(struct)
    IO.inspect(struct)
    Mix.Enums.generate_ecto_enums(Map.get(struct, :enums))
    Mix.Migrations.generate_migrations(Map.get(struct, :types))
    Mix.Schema.generate_schemas(Map.get(struct, :types))
    Mix.Schema.generate_context(Map.get(struct, :types))
    Mix.GraphQL.generate_resolvers(Map.get(struct, :types))
    Mix.GraphQL.generate_types(struct)
    Mix.GraphQL.generate_schema(struct)
  end
end
