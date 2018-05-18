defmodule Mix.Tasks.Valiot.Gen.Api do
  use Mix.Task

  alias ValiotApp.SdlProcessing

  def run(args) do
    [path] = args

    case File.read(path) do
      {:ok, body} ->
        createFiles(SdlProcessing.start_processing(body))

      {:error, reason} ->
        IO.puts("There was an error when opening the file ): Reason: #{reason}")
    end
  end

  defp createFiles({:error, error}) do
    IO.inspect(error)
  end

  defp createFiles({:ok, struct}) do
    case Map.has_key?(struct, :enums) do
      true -> Mix.Enums.generate_ecto_enums(Map.get(struct, :enums))
    end
  end
end
