defmodule ValiotApp.RoleResolver do
  alias ValiotApp.Api
  alias ValiotAppWeb.AuthHelper


  def all(item, args, %{context: %{current_user: current_user}}) do
    case AuthHelper.authorized?(:read, :role, Map.get(current_user, :id)) do
      true -> {:ok, Api.list_roles(args, item)}
      _ -> {:error, "Not Authorized to perform this action"}
    end
  end

  def all(args, %{context: %{current_user: current_user}}) do
    case AuthHelper.authorized?(:read, :role, Map.get(current_user, :id)) do
      true -> {:ok, Api.list_roles(args)}
      _ -> {:error, "Not Authorized to perform this action"}
    end
  end

  def all(_args, _info) do
    {:error, "Not Authorized"}
  end

  def find(%{id: id}, %{context: %{current_user: current_user}}) do
    case AuthHelper.authorized?(:read, :role, Map.get(current_user, :id)) do
      true ->
        case Api.get_role(id) do
          nil -> {:error, "Resource with id #{id} was not found"}
          role -> {:ok, role}
        end

      _ ->
        {:error, "Not Authorized to perform this action"}
    end
  end

  def find(_args, _info) do
    {:error, "Not Authorized"}
  end

  def create(args, %{context: %{current_user: current_user}}) do
    case AuthHelper.authorized?(:create, :role, Map.get(current_user, :id)) do
      true ->
        {_, request} = Api.create_role(args)
        Absinthe.Subscription.publish(ValiotAppWeb.Endpoint, request, role_created: "*")
        {:ok, request}

          _ ->
        {:error, "Not Authorized to perform this action"}

    end
  end

  def create(_args, _info) do
    {:error, "Not Authorized"}
  end

  def update(%{id: id, role: role_params}, %{context: %{current_user: current_user}}) do
    case AuthHelper.authorized?(:update, :role, Map.get(current_user, :id)) do
      true ->
        case Api.get_role(id) do
          nil -> {:error, "Resource with id #{id} was not found"}
          role -> {_, request} = Api.update_role(role, role_params)
            Absinthe.Subscription.publish(ValiotAppWeb.Endpoint, request, role_updated: "*")
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
    case AuthHelper.authorized?(:delete, :role, Map.get(current_user, :id)) do
      true ->
        case Api.get_role(id) do
          nil -> {:error, "Resource with id #{id} was not found"}
          role -> {_, request} = Api.delete_role(role)
            Absinthe.Subscription.publish(ValiotAppWeb.Endpoint, request, role_deleted: "*")
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
