defmodule ValiotAppWeb.Schema.Types do
  use Absinthe.Schema.Notation
  use Absinthe.Ecto, repo: ValiotApp.Repo

  # Enums
  <%= for {enum, values} <- enums do %>
  enum <%= inspect enum |> Atom.to_string |> String.downcase |> String.to_atom %> do<%= for value <- values do %>
    value(<%= inspect value |> String.downcase |> String.to_atom %>)<% end %>
  end
  <% end %>

    <%= for {schema, values} <- types do %>
    enum <%= inspect schema |> Inflex.underscore |> Kernel.<>("_atributes")|> String.to_atom %> do
      value(:id)
      value(:inserted_at)
      value(:updated_at)
      <%= for {type, attrs} <- values do %><%= case Map.get(attrs, :database) do %>
        <% :normal -> %> value(<%= inspect type |> Inflex.underscore |> String.to_atom %>)
        <% :enum -> %> value(<%= inspect type |> Inflex.underscore |> String.to_atom %>)
        <% :belongs_to -> %>
        <% :has_many -> %>
      <% end %><% end %>
    end
    <% end %>
  # Objects

  <%= for {schema, values} <- types do %>
  object <%= inspect schema |> Inflex.underscore |> String.to_atom %> do
    field(:id, :id)
    field(:inserted_at, :datetime)
    field(:updated_at, :datetime)
    <%= for {type, attrs} <- values do %><%= case Map.get(attrs, :database) do %>
    <% :normal -> %>field(<%= inspect type |> Inflex.underscore |> String.to_atom %>, <%= inspect Map.get(attrs, :type) |> Inflex.underscore |> String.to_atom %>)
    <% :has_many -> %>field(<%= inspect type |> Inflex.underscore |> String.to_atom %>, list_of(<%= inspect type |> Inflex.singularize |> Inflex.underscore |> String.to_atom %>))do
      arg(:filter, :filters_<%= type |> Inflex.underscore |> Inflex.singularize %>)
      resolve(&ValiotApp.<%=  type |> Inflex.camelize|> Inflex.singularize%>Resolver.all/3)
    end
    <% :belongs_to -> %>field(<%= inspect type |> Inflex.underscore |> String.to_atom %>, <%= inspect type |> Inflex.underscore |> String.to_atom %>, resolve: assoc(<%= inspect type |> Inflex.underscore |> String.to_atom %>))
    <% :enum -> %>field(<%= inspect type |> Inflex.underscore |> String.to_atom %>, <%= inspect Map.get(attrs, :type) |> String.downcase |> String.to_atom %>)
<% end %><% end %>end
<% end %>
end
