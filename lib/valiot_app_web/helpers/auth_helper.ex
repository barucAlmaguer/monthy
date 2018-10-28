defmodule ValiotAppWeb.AuthHelper do
  @moduledoc false

  import Comeonin.Bcrypt, only: [checkpw: 2]
  import Ecto.Query, warn: false
  alias ValiotApp.Repo
  alias ValiotApp.Api.User

  def login_with_email_pass(email, given_pass) do
    user = Repo.get_by(User, email: String.downcase(email))

    cond do
      user && checkpw(given_pass, user.password_hash) ->
        {:ok, user}

      user ->
        {:error, "Incorrect login credentials"}

      true ->
        {:error, :"User not found"}
    end
  end

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
