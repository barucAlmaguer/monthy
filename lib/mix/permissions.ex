defmodule Mix.Permissions do
  def generate_perms(struct) do
    Map.get(struct, :types)
    |> Enum.concat(Permission: %{"data" => %{data: nil}})
    |> Enum.map(fn {k, _v} -> k |> Inflex.underscore() end)
    |> create_enum()
    |> create_type()
    |> ValiotApp.SdlProcessing.start_processing()
    |> create_struct(struct)
  end

  def create_enum(types) do
    tables =
      for t <- types do
        "  #{String.upcase(t)}\n"
      end

    "\nenum Relation {\n#{tables}}\n"
  end

  def create_type(enum) do
    perms =
      for perm <- ["create", "read", "update", "delete"] do
        "  #{perm}: Boolean @default(value: false)"
      end
      |> Enum.join("\n")

    "\ntype Permission {\n  user_id: Integer!\n  relation: Relation!\n#{perms}}\n#{enum}"
  end

  def create_struct({:ok, perms}, struct) do
    struct_type =
      Map.get(struct, :types)
      |> Enum.concat(Map.get(perms, :types))

    struct_enum =
      Map.get(struct, :enums)
      |> Enum.concat(Map.get(perms, :enums))

    Map.replace!(struct, :types, struct_type)
    |> Map.replace!(:enums, struct_enum)
  end
end
