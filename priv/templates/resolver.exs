defmodule ValiotApp.<%= inspect [Atom.to_string(k)] |> Module.concat %>Resolver do
  alias ValiotApp.Api

  #def all(args, %{context: %{current_user: _current_user}}) do

  def all(args, %{context: %{current_user: _current_user}}) do
    {:ok, Api.list_<%= Atom.to_string(k) |> Inflex.pluralize |> Inflex.underscore %>(args)}
  end

  def all(_args, _info) do
    {:error, "Not Authorized"}
  end

  def find(%{id: id}, %{context: %{current_user: _current_user}}) do
    case Api.get_<%= Atom.to_string(k) |> Inflex.underscore %>(id) do
      nil -> {:error, "Resource with id #{id} was not found"}
      <%= Atom.to_string(k) |> Inflex.underscore %> -> {:ok, <%= Atom.to_string(k) |> Inflex.underscore %>}
    end
  end

  def find(_args, _info) do
    {:error, "Not Authorized"}
  end

  def create(args, %{context: %{current_user: _current_user}}) do
    {:ok, request} = Api.create_<%= Atom.to_string(k) |> Inflex.underscore %>(args)
    Absinthe.Subscription.publish(ValiotAppWeb.Endpoint, request, create_<%= Atom.to_string(k) |> Inflex.underscore %>: "*")
    {:ok, request}

  end

  def create(_args, _info) do
    {:error, "Not Authorized"}
  end

  def update(%{id: id, <%= Atom.to_string(k) |> Inflex.underscore %>: <%= Atom.to_string(k) |> Inflex.underscore %>_params}, %{context: %{current_user: _current_user}}) do
    case Api.get_<%= Atom.to_string(k) |> Inflex.underscore %>(id) do
      nil -> {:error, "Resource with id #{id} was not found"}
      <%= Atom.to_string(k) |> Inflex.underscore %> -> {:ok, request} = Api.update_<%= Atom.to_string(k) |> Inflex.underscore %>(<%= Atom.to_string(k) |> Inflex.underscore %>, <%= Atom.to_string(k) |> Inflex.underscore %>_params)
      Absinthe.Subscription.publish(ValiotAppWeb.Endpoint, request, update_<%= Atom.to_string(k) |> Inflex.underscore %>: "*")
      {:ok, request}
    end
  end

  def update(_args, _info) do
    {:error, "Not Authorized"}
  end

  def delete(%{id: id}, %{context: %{current_user: _current_user}}) do
    case Api.get_<%= Atom.to_string(k) |> Inflex.underscore %>(id) do
      nil -> {:error, "Resource with id #{id} was not found"}
      <%= Atom.to_string(k) |> Inflex.underscore %> -> {:ok, request} = Api.delete_<%= Atom.to_string(k) |> Inflex.underscore %>(<%= Atom.to_string(k) |> Inflex.underscore %>)
      Absinthe.Subscription.publish(ValiotAppWeb.Endpoint, request, delete_<%= Atom.to_string(k) |> Inflex.underscore %>: "*")
      {:ok, request}
    end
  end

  def delete(_args, _info) do
    {:error, "Not Authorized"}
  end
end
