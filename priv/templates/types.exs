defmodule ValiotAppWeb.Schema.Types do
  use Absinthe.Schema.Notation
  use Absinthe.Ecto, repo: ValiotApp.Repo

  # Enums
  <%= for {enum, values} <- enums do %>
  enum <%= inspect enum |> Atom.to_string |> String.downcase |> String.to_atom %> do<%= for value <- values do %>
    value(<%= inspect value |> String.downcase |> String.to_atom %>)<% end %>
  end
  <% end %>

  # Objects

  object :user do
    field(:id, :id)
    field(:name, :string)
    field(:last_name, :string)
    field(:email, :string)
    field(:password, :string)
  end
  <%= for {schema, values} <- types do %>
  object <%= inspect schema |> Inflex.underscore |> String.to_atom %> do
    field(:id, :id)
    <%= for {type, attrs} <- values do %><%= case Map.get(attrs, :database) do %>
    <% :normal -> %>field(<%= inspect type |> Inflex.underscore |> String.to_atom %>, <%= inspect Map.get(attrs, :type) |> Inflex.underscore |> String.to_atom %>)
    <% :has_many -> %>field(<%= inspect type |> Inflex.pluralize |> Inflex.underscore |> String.to_atom %>, list_of(<%= inspect type |> Inflex.underscore |> String.to_atom %>), resolve: assoc(<%= inspect type |> Inflex.pluralize |> Inflex.underscore |> String.to_atom %>))
    <% :belongs_to -> %>field(<%= inspect type |> Inflex.underscore |> String.to_atom %>, <%= inspect type |> Inflex.underscore |> String.to_atom %>, resolve: assoc(<%= inspect type |> Inflex.underscore |> String.to_atom %>))
    <% :enum -> %>field(<%= inspect type |> Inflex.underscore |> String.to_atom %>, <%= inspect Map.get(attrs, :type) |> String.downcase |> String.to_atom %>)
<% end %><% end %>end
<% end %>

  object :session do
    field(:token, :string)
  end
end
