defmodule ValiotApp.Api.<%= inspect [Atom.to_string(k)] |> Module.concat %> do
  use Ecto.Schema
  import Ecto.Changeset

  schema <%= inspect k |> Inflex.underscore |> Inflex.pluralize %> do
    <%= for {type, attrs} <- v do %><%= case Map.get(attrs, :database) do %>
    <% :enum -> %>field(<%= inspect type |> Inflex.underscore |> String.to_atom %>, <%= inspect [Map.get(attrs, :type)] |> Module.concat %>Enum)
    <% :normal -> %>field(<%= inspect type |> Inflex.underscore |> String.to_atom %>, <%= inspect Map.get(attrs, :type) |> Inflex.underscore |> String.to_atom %>)
    <% :belongs_to -> %>belongs_to(<%= inspect type |> Inflex.underscore |> String.to_atom %>, ValiotApp.Api.<%= inspect [Map.get(attrs, :type)] |> Module.concat %>, foreign_key: <%= inspect Map.get(attrs, :type) |> Inflex.underscore |> String.to_atom %>_id)
    <% :has_many -> %>has_many(<%= inspect type |> Inflex.pluralize |> Inflex.underscore |> String.to_atom %>, ValiotApp.Api.<%= inspect [type |> Inflex.singularize |> Inflex.camelize] |> Module.concat %>)
    <% end %><% end %>

    timestamps()
  end

  @doc false
  def changeset(plan, attrs) do
    plan
    |> cast(attrs, [<%= for {type, attrs} <- v do %><%= cond do %><% Map.get(attrs, :database) == :belongs_to -> %><%= inspect type |> Inflex.underscore |> String.to_atom %>_id, <% Map.get(attrs, :database) != :has_many -> %><%= inspect type |> Inflex.underscore |> String.to_atom %>, <% true ->%><% end %><% end %>])
    |> validate_required(<%= inspect Enum.filter(v, fn {type, attrs} -> !Map.get(attrs, :null) end) |> Enum.map(fn {type, attrs} -> if Map.get(attrs, :database) == :belongs_to, do: "#{type |> Inflex.underscore}_id" |> String.to_atom, else: type |> Inflex.underscore |> String.to_atom end) %>)
  end
end
