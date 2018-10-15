defmodule ValiotAppWeb.AuthHelper do
  @moduledoc false

  import Ecto.Query, warn: false
  alias ValiotApp.Repo

  def authorized?(perm, type, id, args) do
    case authorized?(perm, type, id) do
      true ->
        ValiotApp.Api.Permission
        |> where(user_id: ^Map.get(args, :user_id))
        |> where(relation: ^Map.get(args, :relation))
        |> Repo.one()
        |> case do
          nil -> true
          _user -> "Resource already in existance. Try updatePermission."
        end

      false ->
        "Not Authorized to perform this action"
    end
  end

  def authorized?(perm, type, id) do
    ValiotApp.Api.Permission
    |> where(user_id: ^id)
    |> where(relation: ^type)
    |> where([p], field(p, ^perm) == true)
    |> Repo.one()
    |> case do
      nil -> false
      _user -> true
    end
  end
end
