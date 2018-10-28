defmodule ValiotApp.AreaResolver do
  alias ValiotApp.Api
  alias ValiotAppWeb.AuthHelper


  def all(item, args, %{context: %{current_token: current_token}}) do
    case AuthHelper.authorized?(:read, :area, Map.get(current_token, :id)) do
      true -> {:ok, Api.list_areas(args, item)}
      _ -> {:error, "Not Authorized to perform this action"}
    end
  end

  def all(args, %{context: %{current_token: current_token}}) do
    case AuthHelper.authorized?(:read, :area, Map.get(current_token, :id)) do
      true -> {:ok, Api.list_areas(args)}
      _ -> {:error, "Not Authorized to perform this action"}
    end
  end

  def all(_args, _info) do
    {:error, "Not Authorized"}
  end

  def find(%{id: id}, %{context: %{current_token: current_token}}) do
    case AuthHelper.authorized?(:read, :area, Map.get(current_token, :id)) do
      true ->
        case Api.get_area(id) do
          nil -> {:error, "Resource with id #{id} was not found"}
          area -> {:ok, area}
        end

      _ ->
        {:error, "Not Authorized to perform this action"}
    end
  end

  def find(_args, _info) do
    {:error, "Not Authorized"}
  end

  def create(args, %{context: %{current_token: current_token}}) do
    case AuthHelper.authorized?(:create, :area, Map.get(current_token, :id)) do
      true ->
        {_, request} = Api.create_area(args)
        Absinthe.Subscription.publish(ValiotAppWeb.Endpoint, request, area_created: "*")
        {:ok, request}
      
          _ ->
        {:error, "Not Authorized to perform this action"}
      
    end
  end

  def create(_args, _info) do
    {:error, "Not Authorized"}
  end

  def update(%{id: id, area: area_params}, %{context: %{current_token: current_token}}) do
    case AuthHelper.authorized?(:update, :area, Map.get(current_token, :id)) do
      true ->
        case Api.get_area(id) do
          nil -> {:error, "Resource with id #{id} was not found"}
          area -> {_, request} = Api.update_area(area, area_params)
            Absinthe.Subscription.publish(ValiotAppWeb.Endpoint, request, area_updated: "*")
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
    case AuthHelper.authorized?(:delete, :area, Map.get(current_token, :id)) do
      true ->
        case Api.get_area(id) do
          nil -> {:error, "Resource with id #{id} was not found"}
          area -> {_, request} = Api.delete_area(area)
            Absinthe.Subscription.publish(ValiotAppWeb.Endpoint, request, area_deleted: "*")
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
