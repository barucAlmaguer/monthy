defmodule ValiotApp.AreaIssueResolver do
  alias ValiotApp.Api
  alias ValiotAppWeb.AuthHelper


  def all(item, args, %{context: %{current_user: current_user}}) do
    case AuthHelper.authorized?(:read, :area_issue, Map.get(current_user, :id)) do
      true -> {:ok, Api.list_area_issues(args, item)}
      _ -> {:error, "Not Authorized to perform this action"}
    end
  end

  def all(args, %{context: %{current_user: current_user}}) do
    case AuthHelper.authorized?(:read, :area_issue, Map.get(current_user, :id)) do
      true -> {:ok, Api.list_area_issues(args)}
      _ -> {:error, "Not Authorized to perform this action"}
    end
  end

  def all(_args, _info) do
    {:error, "Not Authorized"}
  end

  def find(%{id: id}, %{context: %{current_user: current_user}}) do
    case AuthHelper.authorized?(:read, :area_issue, Map.get(current_user, :id)) do
      true ->
        case Api.get_area_issue(id) do
          nil -> {:error, "Resource with id #{id} was not found"}
          area_issue -> {:ok, area_issue}
        end

      _ ->
        {:error, "Not Authorized to perform this action"}
    end
  end

  def find(_args, _info) do
    {:error, "Not Authorized"}
  end

  def create(args, %{context: %{current_user: current_user}}) do
    case AuthHelper.authorized?(:create, :area_issue, Map.get(current_user, :id)) do
      true ->
        {_, request} = Api.create_area_issue(args)
        Absinthe.Subscription.publish(ValiotAppWeb.Endpoint, request, area_issue_created: "*")
        {:ok, request}

          _ ->
        {:error, "Not Authorized to perform this action"}

    end
  end

  def create(_args, _info) do
    {:error, "Not Authorized"}
  end

  def update(%{id: id, area_issue: area_issue_params}, %{context: %{current_user: current_user}}) do
    case AuthHelper.authorized?(:update, :area_issue, Map.get(current_user, :id)) do
      true ->
        case Api.get_area_issue(id) do
          nil -> {:error, "Resource with id #{id} was not found"}
          area_issue -> {_, request} = Api.update_area_issue(area_issue, area_issue_params)
            Absinthe.Subscription.publish(ValiotAppWeb.Endpoint, request, area_issue_updated: "*")
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
    case AuthHelper.authorized?(:delete, :area_issue, Map.get(current_user, :id)) do
      true ->
        case Api.get_area_issue(id) do
          nil -> {:error, "Resource with id #{id} was not found"}
          area_issue -> {_, request} = Api.delete_area_issue(area_issue)
            Absinthe.Subscription.publish(ValiotAppWeb.Endpoint, request, area_issue_deleted: "*")
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
