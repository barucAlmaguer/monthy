defmodule ValiotApp.Repo.Migrations.Create<%= inspect [Atom.to_string(k) |> Inflex.pluralize] |> Module.concat %> do
  use Ecto.Migration

  def up do
    <%= for {type, attrs} <- Enum.filter(v, fn {type, attrs} -> Map.get(attrs, :database) == :enum end) do %>
    <%= inspect [Map.get(attrs, :type)] |> Module.concat %>Enum.create_type<% end %>
    create table(<%= inspect Inflex.underscore(k) |> Inflex.pluralize |> String.to_atom %>) do
      <%= for {type, attrs} <- v do %><%= case Map.get(attrs, :database) do %>
      <% :enum -> %>add(<%= inspect type |> Inflex.underscore |> String.to_atom %>, <%= inspect Map.get(attrs, :type) |> Inflex.underscore |> String.to_atom %>)
      <% :normal -> %>add(<%= inspect type |> Inflex.underscore |> String.to_atom %>, <%= inspect Map.get(attrs, :type) |> Inflex.underscore |> String.to_atom %><%= if Map.get(attrs, :default) do %>, default: <%= inspect Map.get(attrs, :default) %><% end %>)
      <% :belongs_to -> %>add(<%= inspect Map.get(attrs, :type) |> Inflex.underscore |> String.to_atom %>_id, references(<%= inspect Map.get(attrs, :type) |> Inflex.underscore |> Inflex.pluralize |> String.to_atom %>, on_delete: :nothing))
      <% _ -> %><% end %><% end %>

      timestamps()
    end
    <%= for {type, attrs} <- Enum.filter(v, fn {type, attrs} -> Map.get(attrs, :database) == :belongs_to end) do %>
    create index(<%= inspect Inflex.underscore(k) |> Inflex.pluralize |> String.to_atom %>, [<%= inspect Map.get(attrs, :type) |> Inflex.underscore |> String.to_atom %>_id])<% end %>
  end

  def down do
    drop table(<%= inspect Inflex.underscore(k) |> Inflex.pluralize |> String.to_atom %>)
    <%= for {type, attrs} <- Enum.filter(v, fn {type, attrs} -> Map.get(attrs, :database) == :enum end) do %>
    <%= inspect [Map.get(attrs, :type)] |> Module.concat %>Enum.drop_type<% end %>
  end
end
