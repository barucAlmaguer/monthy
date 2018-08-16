defmodule ValiotApp.<%= inspect [Atom.to_string(k)] |> Module.concat %>Resolver do
  alias ValiotApp.Api
  alias ValiotAppWeb.AuthHelper


  def all(item, args, %{context: %{current_user: current_user}}) do
    case AuthHelper.authorized?(:read, :<%= Atom.to_string(k) |> Inflex.underscore %>, Map.get(current_user, :id)) do
      true -> {:ok, Api.list_<%= Atom.to_string(k) |> Inflex.pluralize |> Inflex.underscore %>(args, item)}
      _ -> {:error, "Not Authorized to perform this action"}
    end
  end

  def all(args, %{context: %{current_user: current_user}}) do
    case AuthHelper.authorized?(:read, :<%= Atom.to_string(k) |> Inflex.underscore %>, Map.get(current_user, :id)) do
      true -> {:ok, Api.list_<%= Atom.to_string(k) |> Inflex.pluralize |> Inflex.underscore %>(args)}
      _ -> {:error, "Not Authorized to perform this action"}
    end
  end

  def all(_args, _info) do
    {:error, "Not Authorized"}
  end

  def find(%{id: id}, %{context: %{current_user: current_user}}) do
    case AuthHelper.authorized?(:read, :<%= Atom.to_string(k) |> Inflex.underscore %>, Map.get(current_user, :id)) do
      true ->
        case Api.get_<%= Atom.to_string(k) |> Inflex.underscore %>(id) do
          nil -> {:error, "Resource with id #{id} was not found"}
          <%= Atom.to_string(k) |> Inflex.underscore %> -> {:ok, <%= Atom.to_string(k) |> Inflex.underscore %>}
        end

      _ ->
        {:error, "Not Authorized to perform this action"}
    end
  end

  def find(_args, _info) do
    {:error, "Not Authorized"}
  end

  def create(args, %{context: %{current_user: current_user}}) do
    case AuthHelper.authorized?(:create, :<%= Atom.to_string(k) |> Inflex.underscore %>, Map.get(current_user, :id)<%= if Atom.to_string(k) |> Inflex.underscore == "permission" do %>, args<% end %>) do
      true ->
        {:ok, request} = Api.create_<%= Atom.to_string(k) |> Inflex.underscore %>(args)
        Absinthe.Subscription.publish(ValiotAppWeb.Endpoint, request, create_<%= Atom.to_string(k) |> Inflex.underscore %>: "*")
        {:ok, request}
      <%= case Atom.to_string(k) |> Inflex.underscore do %>
        <% "permission" -> %>
          msg ->
        {:error, msg}
        <% _ -> %>
          _ ->
        {:error, "Not Authorized to perform this action"}
      <% end %>
    end
  end

  def create(_args, _info) do
    {:error, "Not Authorized"}
  end

  def update(%{id: id, <%= Atom.to_string(k) |> Inflex.underscore %>: <%= Atom.to_string(k) |> Inflex.underscore %>_params}, %{context: %{current_user: current_user}}) do
    case AuthHelper.authorized?(:update, :<%= Atom.to_string(k) |> Inflex.underscore %>, Map.get(current_user, :id)) do
      true ->
        case Api.get_<%= Atom.to_string(k) |> Inflex.underscore %>(id) do
          nil -> {:error, "Resource with id #{id} was not found"}
          <%= Atom.to_string(k) |> Inflex.underscore %> -> {:ok, request} = Api.update_<%= Atom.to_string(k) |> Inflex.underscore %>(<%= Atom.to_string(k) |> Inflex.underscore %>, <%= Atom.to_string(k) |> Inflex.underscore %>_params)
            Absinthe.Subscription.publish(ValiotAppWeb.Endpoint, request, update_<%= Atom.to_string(k) |> Inflex.underscore %>: "*")
            {:ok, request}
        end

      _ ->
        {:error, "Not Authorized to perform this action"}

    end
  end

  def update(_args, _info) do
    {:error, "Not Authorized"}
  end

  def delete(%{id: id}, %{context: %{current_user: current_user}}) do
    case AuthHelper.authorized?(:delete, :<%= Atom.to_string(k) |> Inflex.underscore %>, Map.get(current_user, :id)) do
      true ->
        case Api.get_<%= Atom.to_string(k) |> Inflex.underscore %>(id) do
          nil -> {:error, "Resource with id #{id} was not found"}
          <%= Atom.to_string(k) |> Inflex.underscore %> -> {:ok, request} = Api.delete_<%= Atom.to_string(k) |> Inflex.underscore %>(<%= Atom.to_string(k) |> Inflex.underscore %>)
            Absinthe.Subscription.publish(ValiotAppWeb.Endpoint, request, delete_<%= Atom.to_string(k) |> Inflex.underscore %>: "*")
            {:ok, request}
        end

      _ ->
        {:error, "Not Authorized to perform this action"}
    end
  end

  def delete(_args, _info) do
    {:error, "Not Authorized"}
  end
end
