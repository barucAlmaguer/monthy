defmodule ValiotApp.ProjectResolver do
  alias ValiotApp.Api
  alias ValiotAppWeb.AuthHelper


  def all(item, args, %{context: %{current_user: current_user}}) do
    case AuthHelper.authorized?(:read, :project, Map.get(current_user, :id)) do
      true -> {:ok, Api.list_projects(args, item)}
      _ -> {:error, "Not Authorized to perform this action"}
    end
  end

  def all(args, %{context: %{current_user: current_user}}) do
    case AuthHelper.authorized?(:read, :project, Map.get(current_user, :id)) do
      true -> {:ok, Api.list_projects(args)}
      _ -> {:error, "Not Authorized to perform this action"}
    end
  end

  def all(_args, _info) do
    {:error, "Not Authorized"}
  end

  def find(%{id: id}, %{context: %{current_user: current_user}}) do
    case AuthHelper.authorized?(:read, :project, Map.get(current_user, :id)) do
      true ->
        case Api.get_project(id) do
          nil -> {:error, "Resource with id #{id} was not found"}
          project -> {:ok, project}
        end

      _ ->
        {:error, "Not Authorized to perform this action"}
    end
  end

  def find(_args, _info) do
    {:error, "Not Authorized"}
  end

  def create(args, %{context: %{current_user: current_user}}) do
    case AuthHelper.authorized?(:create, :project, Map.get(current_user, :id)) do
      true ->
        {_, request} = Api.create_project(args)
        Absinthe.Subscription.publish(ValiotAppWeb.Endpoint, request, project_created: "*")
        {:ok, request}

          _ ->
        {:error, "Not Authorized to perform this action"}

    end
  end

  def create(_args, _info) do
    {:error, "Not Authorized"}
  end

  def update(%{id: id, project: project_params}, %{context: %{current_user: current_user}}) do
    case AuthHelper.authorized?(:update, :project, Map.get(current_user, :id)) do
      true ->
        case Api.get_project(id) do
          nil -> {:error, "Resource with id #{id} was not found"}
          project -> {_, request} = Api.update_project(project, project_params)
            Absinthe.Subscription.publish(ValiotAppWeb.Endpoint, request, project_updated: "*")
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
    case AuthHelper.authorized?(:delete, :project, Map.get(current_user, :id)) do
      true ->
        case Api.get_project(id) do
          nil -> {:error, "Resource with id #{id} was not found"}
          project -> {_, request} = Api.delete_project(project)
            Absinthe.Subscription.publish(ValiotAppWeb.Endpoint, request, project_deleted: "*")
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
