defmodule ValiotApp.SdlProcessing do
  alias ValiotApp.Validations

  def start_processing(body) do
    case Validations.correct_brackets(body) do
      true -> to_struct(body)
      false -> {:error, "Invalid format"}
    end
  end

  defp to_struct(body) do
    enums = body |> extractEnums |> toMap(:enum, [])
    types = body |> extractTypes |> toMap(:types, enums)

    struct = %{
      types: types,
      enums: enums
    }

    case Validations.invalid_types(struct) do
      true -> {:error, "Invalid types"}
      false -> {:ok, struct |> sort_by_relations()}
    end
  end

  defp sort_by_relations(struct) do
    %{types: types, enums: enums} = struct

    valid_types =
      [
        "Float",
        "Integer",
        "String",
        "Boolean",
        "NaiveDatetime",
        "DateTime",
        "Date",
        "Text"
      ] ++
        Enum.map(enums, fn {k, _} -> Atom.to_string(k) end) ++
        Enum.map(types, fn {k, _} -> "[#{Atom.to_string(k)}]" end)

    types =
      types
      |> Keyword.to_list()
      |> sort_func(Keyword.new(), valid_types)

    %{types: types, enums: enums}
  end

  defp sort_func([], sorted, _), do: sorted

  defp sort_func([{k, v} | rest], sorted, types) do
    cond do
      !has_relations?(v, types) ->
        sort_func(rest, sorted ++ [{k, v}], types)

      !has_missing_dependencies?(v, sorted, types) ->
        sort_func(rest, sorted ++ [{k, v}], types)

      true ->
        sort_func(rest ++ [{k, v}], sorted, types)
    end
  end

  defp has_relations?(attrs, types) do
    Enum.any?(attrs, fn {_, attr} ->
      :has_one != Map.get(attr, :database) && !Enum.member?(types, Map.get(attr, :type))
    end)
  end

  defp has_missing_dependencies?(v, sorted, _types) do
    # Check that it's a dependency using belongs_to
    dependencies =
      Enum.filter(v, fn {_, v} -> Map.get(v, :database) == :belongs_to end)
      |> Enum.map(fn {_, v} -> Map.get(v, :type) end)

    sorted_dependencies =
      Enum.map(sorted, fn {k, _} ->
        Atom.to_string(k)
      end)

    Enum.any?(dependencies, fn t -> !Enum.member?(sorted_dependencies, t) end)
  end

  defp extractTypes(body) do
    ~r/(?<=type)\s*\w+\s*\{[\s\w:!@()\d\."\[\]]*\}/s
    |> Regex.scan(body)
    |> List.flatten()
  end

  defp extractEnums(body) do
    ~r/(?<=enum)\s*\w+\s*\{[\s\w]*\}/s
    |> Regex.scan(body)
    |> List.flatten()
  end

  defp attributeMap(lst, enums, map \\ %{})

  defp attributeMap([h | t], enums, map) do
    [name, body] = String.split(h, ~r/\s*:\s*/, parts: 2)
    [[type] | _] = Regex.scan(~r/\w*/, body)
    null = Regex.match?(~r/!/, body)

    default =
      case Regex.run(~r/(?<=@default\(value:)\s[\w\d\."]*/, body) do
        [value] -> String.trim(value) |> Jason.decode!()
        nil -> nil
      end

    unique =
      case Regex.run(~r/@unique/, body) do
        nil -> false
        _ -> true
      end

    has_one =
      case Regex.run(~r/@has_one/, body) do
        nil -> false
        _ -> true
      end

    valid_types = [
      "Float",
      "Integer",
      "String",
      "Boolean",
      "NaiveDatetime",
      "DateTime",
      "Date",
      "Text"
    ]

    database =
      cond do
        type == "" -> :has_many
        has_one -> :has_one
        Enum.member?(valid_types, type) -> :normal
        Enum.map(enums, fn {k, _} -> Atom.to_string(k) end) |> Enum.member?(type) -> :enum
        true -> :belongs_to
      end

    type = if type == "", do: body, else: type

    attributeMap(
      t,
      enums,
      Map.put(map, name, %{
        type: type,
        unique: unique,
        null: !null,
        default: default,
        database: database
      })
    )
  end

  defp attributeMap([], _, map), do: map

  defp toMap(lst, type, enums, map \\ Keyword.new())

  defp toMap([], _, _, map), do: map

  defp toMap([h | t], type, enums, map) do
    lst =
      String.replace(h, ~r/\s*}/, "")
      |> String.split(" {")

    [key, body] = lst

    attrs =
      body
      |> String.trim()
      |> String.split(~r/\n\s*/)

    attrs =
      case type do
        :enum -> attrs
        :types -> attrs |> attributeMap(enums)
      end

    key = key |> String.trim() |> String.to_atom()

    toMap(t, type, enums, Keyword.put(map, key, attrs))
  end
end
