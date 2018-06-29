defmodule ValiotApp.Api do
  import Ecto.Query, warn: false
  alias ValiotApp.Repo
  alias ValiotApp.Api

  <%= for {k, values} <- types do %><% singular_schema = k |> Inflex.underscore; module = inspect [Atom.to_string(k)] |> Module.concat %>

  def list_<%= k |> Inflex.underscore |> Inflex.pluralize %> do
    Repo.all(Api.<%= module %>)
  end

  def list_<%= k |> Inflex.underscore |> Inflex.pluralize %>(filters) do
    filters
    |> Enum.reduce(Api.<%= module %>, fn
      {_, nil}, query ->
        query

      {:filter, filter}, query ->
        query |> filter_<%= k |> Inflex.underscore |> Inflex.pluralize %>(filter)
    end)
    |> Repo.all()
  end

  def get_<%= singular_schema %>!(id), do: Repo.get!(Api.<%= module %>, id)
  def get_<%= singular_schema %>(id), do: Repo.get(Api.<%= module %>, id)

  def create_<%= singular_schema %>(attrs \\ %{}) do
    %Api.<%= module %>{}
    |> Api.<%= module %>.changeset(attrs)
    |> Repo.insert()
  end

  def update_<%= singular_schema %>(%Api.<%= module %>{} = <%= singular_schema %>, attrs) do
    <%= singular_schema %>
    |> Api.<%= module %>.changeset(attrs)
    |> Repo.update()
  end

  def delete_<%= singular_schema %>(%Api.<%= module %>{} = <%= singular_schema %>) do
    Repo.delete(<%= singular_schema %>)
  end

  def change_<%= singular_schema %>(%Api.<%= module %>{} = <%= singular_schema %>) do
    Api.<%= module %>.changeset(<%= singular_schema %>, %{})
  end

  def filter_<%= k |> Inflex.underscore |> Inflex.pluralize %>(query, filter) do
    Enum.reduce(filter, query, fn
      {:id, id}, query ->
        from(q in query, where: q.id == ^id)
      {:before, date}, query ->
        from q in query, where: q.inserted_at <= ^date
      {:after, date}, query ->
        from q in query, where: q.inserted_at >= ^date
      <%= for {type, attrs} <- values do %><%= case Map.get(attrs, :database) do %>
      <% :normal -> %>{<%= inspect type |> Inflex.underscore |> String.to_atom %>, <%= type |> Inflex.underscore %>}, query ->
      from(q in query, where: q.<%= type |> Inflex.underscore %> == ^<%= type |> Inflex.underscore %>)
      <% :has_many -> %>
      <% :belongs_to -> %>
      <% :enum -> %>{<%= inspect type |> Inflex.underscore |> String.to_atom %>, <%= type |> Inflex.underscore %>}, query ->
      from(q in query, where: q.<%= type |> Inflex.underscore  %> == ^<%= type |> Inflex.underscore  %>)<% end %>
      <% end %>
    end)
  end<% end %>
end
