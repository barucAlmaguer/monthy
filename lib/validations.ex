defmodule ValiotApp.Validations do
  def invalid_types(struct) do
    %{types: types, enums: enums} = struct

    valid_types =
      [
        "Float",
        "Integer",
        "ID",
        "String",
        "Boolean",
        "NaiveDatetime",
        "DateTime",
        "Date",
        "Text"
      ] ++
        Enum.map(enums, fn {k, _} -> Atom.to_string(k) end) ++
        Enum.map(types, fn {k, _} -> Atom.to_string(k) end) ++
        Enum.map(types, fn {k, _} -> "[#{Atom.to_string(k)}]" end)

    Enum.map(types, fn {_k, v} -> Enum.map(v, fn {_type, val} -> Map.get(val, :type) end) end)
    |> List.flatten()
    |> Enum.uniq()
    |> Enum.any?(fn t ->
      !Enum.member?(valid_types, t)
    end)
  end

  def correct_brackets(body) do
    left_b =
      ~r/{/
      |> Regex.scan(body)
      |> List.flatten()
      |> length

    right_b =
      ~r/}/
      |> Regex.scan(body)
      |> List.flatten()
      |> length

    right_b == left_b
  end
end
