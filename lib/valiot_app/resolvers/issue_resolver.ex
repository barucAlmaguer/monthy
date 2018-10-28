defmodule ValiotApp.IssueResolver do
  alias ValiotApp.Api
  alias ValiotAppWeb.AuthHelper


  def all(item, args, %{context: %{current_user: current_user}}) do
    case AuthHelper.authorized?(:read, :issue, Map.get(current_user, :id)) do
      true -> {:ok, Api.list_issues(args, item)}
      _ -> {:error, "Not Authorized to perform this action"}
    end
  end

  def all(args, %{context: %{current_user: current_user}}) do
    case AuthHelper.authorized?(:read, :issue, Map.get(current_user, :id)) do
      true -> {:ok, Api.list_issues(args)}
      _ -> {:error, "Not Authorized to perform this action"}
    end
  end

  def all(_args, _info) do
    {:error, "Not Authorized"}
  end

  def find(%{id: id}, %{context: %{current_user: current_user}}) do
    case AuthHelper.authorized?(:read, :issue, Map.get(current_user, :id)) do
      true ->
        case Api.get_issue(id) do
          nil -> {:error, "Resource with id #{id} was not found"}
          issue -> {:ok, issue}
        end

      _ ->
        {:error, "Not Authorized to perform this action"}
    end
  end

  def find(_args, _info) do
    {:error, "Not Authorized"}
  end

  def create(args, %{context: %{current_user: current_user}}) do
    case AuthHelper.authorized?(:create, :issue, Map.get(current_user, :id)) do
      true ->
        {_, request} = Api.create_issue(args)
        Absinthe.Subscription.publish(ValiotAppWeb.Endpoint, request, issue_created: "*")
        {:ok, request}

          _ ->
        {:error, "Not Authorized to perform this action"}

    end
  end

  def create(_args, _info) do
    {:error, "Not Authorized"}
  end

  def update(%{id: id, issue: issue_params}, %{context: %{current_user: current_user}}) do
    case AuthHelper.authorized?(:update, :issue, Map.get(current_user, :id)) do
      true ->
        case Api.get_issue(id) do
          nil -> {:error, "Resource with id #{id} was not found"}
          issue -> {_, request} = Api.update_issue(issue, issue_params)
            Absinthe.Subscription.publish(ValiotAppWeb.Endpoint, request, issue_updated: "*")
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
    case AuthHelper.authorized?(:delete, :issue, Map.get(current_user, :id)) do
      true ->
        case Api.get_issue(id) do
          nil -> {:error, "Resource with id #{id} was not found"}
          issue -> {_, request} = Api.delete_issue(issue)
            Absinthe.Subscription.publish(ValiotAppWeb.Endpoint, request, issue_deleted: "*")
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
