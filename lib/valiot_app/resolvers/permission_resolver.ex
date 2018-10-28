defmodule ValiotApp.PermissionResolver do
  alias ValiotApp.Api
  alias ValiotAppWeb.AuthHelper


  def all(item, args, %{context: %{current_token: current_token}}) do
    case AuthHelper.authorized?(:read, :permission, Map.get(current_token, :id)) do
      true -> {:ok, Api.list_permissions(args, item)}
      _ -> {:error, "Not Authorized to perform this action"}
    end
  end

  def all(args, %{context: %{current_token: current_token}}) do
    case AuthHelper.authorized?(:read, :permission, Map.get(current_token, :id)) do
      true -> {:ok, Api.list_permissions(args)}
      _ -> {:error, "Not Authorized to perform this action"}
    end
  end

  def all(_args, _info) do
    {:error, "Not Authorized"}
  end

  def find(%{id: id}, %{context: %{current_token: current_token}}) do
    case AuthHelper.authorized?(:read, :permission, Map.get(current_token, :id)) do
      true ->
        case Api.get_permission(id) do
          nil -> {:error, "Resource with id #{id} was not found"}
          permission -> {:ok, permission}
        end

      _ ->
        {:error, "Not Authorized to perform this action"}
    end
  end

  def find(_args, _info) do
    {:error, "Not Authorized"}
  end

  def create(args, %{context: %{current_token: current_token}}) do
    case AuthHelper.authorized?(:create, :permission, Map.get(current_token, :id), args) do
      true ->
        {_, request} = Api.create_permission(args)
        Absinthe.Subscription.publish(ValiotAppWeb.Endpoint, request, permission_created: "*")
        {:ok, request}
      
          msg ->
        {:error, msg}
        
    end
  end

  def create(_args, _info) do
    {:error, "Not Authorized"}
  end

  def update(%{id: id, permission: permission_params}, %{context: %{current_token: current_token}}) do
    case AuthHelper.authorized?(:update, :permission, Map.get(current_token, :id)) do
      true ->
        case Api.get_permission(id) do
          nil -> {:error, "Resource with id #{id} was not found"}
          permission -> {_, request} = Api.update_permission(permission, permission_params)
            Absinthe.Subscription.publish(ValiotAppWeb.Endpoint, request, permission_updated: "*")
            {:ok, request}
        end

      _ ->
        {:error, "Not Authorized to perform this action"}

    end
  end

  def update(_args, _info) do
    {:error, "Not Authorized"}
  end

  def delete(%{id: id}, %{context: %{current_token: current_token}}) do
    case AuthHelper.authorized?(:delete, :permission, Map.get(current_token, :id)) do
      true ->
        case Api.get_permission(id) do
          nil -> {:error, "Resource with id #{id} was not found"}
          permission -> {_, request} = Api.delete_permission(permission)
            Absinthe.Subscription.publish(ValiotAppWeb.Endpoint, request, permission_deleted: "*")
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
