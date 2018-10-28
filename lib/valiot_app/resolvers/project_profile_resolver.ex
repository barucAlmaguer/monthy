defmodule ValiotApp.ProjectProfileResolver do
  alias ValiotApp.Api
  alias ValiotAppWeb.AuthHelper


  def all(item, args, %{context: %{current_token: current_token}}) do
    case AuthHelper.authorized?(:read, :project_profile, Map.get(current_token, :id)) do
      true -> {:ok, Api.list_project_profiles(args, item)}
      _ -> {:error, "Not Authorized to perform this action"}
    end
  end

  def all(args, %{context: %{current_token: current_token}}) do
    case AuthHelper.authorized?(:read, :project_profile, Map.get(current_token, :id)) do
      true -> {:ok, Api.list_project_profiles(args)}
      _ -> {:error, "Not Authorized to perform this action"}
    end
  end

  def all(_args, _info) do
    {:error, "Not Authorized"}
  end

  def find(%{id: id}, %{context: %{current_token: current_token}}) do
    case AuthHelper.authorized?(:read, :project_profile, Map.get(current_token, :id)) do
      true ->
        case Api.get_project_profile(id) do
          nil -> {:error, "Resource with id #{id} was not found"}
          project_profile -> {:ok, project_profile}
        end

      _ ->
        {:error, "Not Authorized to perform this action"}
    end
  end

  def find(_args, _info) do
    {:error, "Not Authorized"}
  end

  def create(args, %{context: %{current_token: current_token}}) do
    case AuthHelper.authorized?(:create, :project_profile, Map.get(current_token, :id)) do
      true ->
        {_, request} = Api.create_project_profile(args)
        Absinthe.Subscription.publish(ValiotAppWeb.Endpoint, request, project_profile_created: "*")
        {:ok, request}
      
          _ ->
        {:error, "Not Authorized to perform this action"}
      
    end
  end

  def create(_args, _info) do
    {:error, "Not Authorized"}
  end

  def update(%{id: id, project_profile: project_profile_params}, %{context: %{current_token: current_token}}) do
    case AuthHelper.authorized?(:update, :project_profile, Map.get(current_token, :id)) do
      true ->
        case Api.get_project_profile(id) do
          nil -> {:error, "Resource with id #{id} was not found"}
          project_profile -> {_, request} = Api.update_project_profile(project_profile, project_profile_params)
            Absinthe.Subscription.publish(ValiotAppWeb.Endpoint, request, project_profile_updated: "*")
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
    case AuthHelper.authorized?(:delete, :project_profile, Map.get(current_token, :id)) do
      true ->
        case Api.get_project_profile(id) do
          nil -> {:error, "Resource with id #{id} was not found"}
          project_profile -> {_, request} = Api.delete_project_profile(project_profile)
            Absinthe.Subscription.publish(ValiotAppWeb.Endpoint, request, project_profile_deleted: "*")
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
