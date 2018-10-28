defmodule ValiotApp.UserResolver do
  alias ValiotApp.Api

  def login(%{email: email, password: password}, _info) do
    with {:ok, user} <- ValiotAppWeb.AuthHelper.login_with_email_pass(email, password),
         {:ok, jwt, _} <- ValiotAppWeb.Guardian.encode_and_sign(user),
         {:ok, _} <- Api.store_token(user, jwt) do
      {:ok, %{token: jwt}}
    end
  end

  def logout(_args, %{context: %{current_user: current_user, token: _token}}) do
    Api.revoke_token(current_user, nil)
    {:ok, current_user}
  end

  def logout(_args, _info) do
    {:error, "Please log in first!"}
  end

  def all(_args, %{context: %{current_user: _current_user}}) do
    {:ok, Api.list_users()}
  end

  def all(_args, _info) do
    {:error, "Not Authorized"}
  end

  def find(%{id: id}, %{context: %{current_user: _current_user}}) do
    case Api.get_user(id) do
      nil -> {:error, "User id #{id} not found"}
      user -> {:ok, user}
    end
  end

  def find(_args, _info) do
    {:error, "Not Authorized"}
  end

  def create(args, _info) do
    Api.create_user(args)
  end

  def update(%{id: id, user: user_params}, %{context: %{current_user: _current_user}}) do
    case Api.get_user(id) do
      nil -> {:error, "User id #{id} not found"}
      user -> Api.update_user(user, user_params)
    end
  end

  def update(_args, _info) do
    {:error, "Not Authorized"}
  end

  def delete(%{id: id}, %{context: %{current_user: _current_user}}) do
    case Api.get_user(id) do
      nil -> {:error, "User id #{id} not found"}
      user -> Api.delete_user(user)
    end
  end

  def delete(_args, _info) do
    {:error, "Not Authorized"}
  end
end
