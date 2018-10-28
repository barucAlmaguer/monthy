defmodule ValiotApp.ProfileResolver do
  alias ValiotApp.Api
  alias ValiotAppWeb.AuthHelper


  def all(item, args, %{context: %{current_user: current_user}}) do
    case AuthHelper.authorized?(:read, :profile, Map.get(current_user, :id)) do
      true -> {:ok, Api.list_profiles(args, item)}
      _ -> {:error, "Not Authorized to perform this action"}
    end
  end

  def all(args, %{context: %{current_user: current_user}}) do
    case AuthHelper.authorized?(:read, :profile, Map.get(current_user, :id)) do
      true -> {:ok, Api.list_profiles(args)}
      _ -> {:error, "Not Authorized to perform this action"}
    end
  end

  def all(_args, _info) do
    {:error, "Not Authorized"}
  end

  def find(%{id: id}, %{context: %{current_user: current_user}}) do
    case AuthHelper.authorized?(:read, :profile, Map.get(current_user, :id)) do
      true ->
        case Api.get_profile(id) do
          nil -> {:error, "Resource with id #{id} was not found"}
          profile -> {:ok, profile}
        end

      _ ->
        {:error, "Not Authorized to perform this action"}
    end
  end

  def find(_args, _info) do
    {:error, "Not Authorized"}
  end

  def create(args, %{context: %{current_user: current_user}}) do
    case AuthHelper.authorized?(:create, :profile, Map.get(current_user, :id)) do
      true ->
        {_, request} = Api.create_profile(args)
        Absinthe.Subscription.publish(ValiotAppWeb.Endpoint, request, profile_created: "*")
        {:ok, request}

          _ ->
        {:error, "Not Authorized to perform this action"}

    end
  end

  def create(_args, _info) do
    {:error, "Not Authorized"}
  end

  def update(%{id: id, profile: profile_params}, %{context: %{current_user: current_user}}) do
    case AuthHelper.authorized?(:update, :profile, Map.get(current_user, :id)) do
      true ->
        case Api.get_profile(id) do
          nil -> {:error, "Resource with id #{id} was not found"}
          profile -> {_, request} = Api.update_profile(profile, profile_params)
            Absinthe.Subscription.publish(ValiotAppWeb.Endpoint, request, profile_updated: "*")
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
    case AuthHelper.authorized?(:delete, :profile, Map.get(current_user, :id)) do
      true ->
        case Api.get_profile(id) do
          nil -> {:error, "Resource with id #{id} was not found"}
          profile -> {_, request} = Api.delete_profile(profile)
            Absinthe.Subscription.publish(ValiotAppWeb.Endpoint, request, profile_deleted: "*")
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
