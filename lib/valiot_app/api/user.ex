defmodule ValiotApp.Api.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field(:email, :string)
    field(:password, :string, virtual: true)
    field(:password_hash, :string)
    field(:token, :string)

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :password_hash])
    |> validate_required([:email])
  end

  def update_changeset(user, params \\ %{}) do
    user
    |> cast(params, [:email], [:password])
    |> validate_required([:email])
    |> put_pass_hash
  end

  def registration_changeset(user, params \\ %{}) do
    user
    |> cast(params, [:email, :password])
    |> validate_required([:email, :password])
    |> put_pass_hash
  end

  def store_token_changeset(user, params \\ %{}) do
    user
    |> cast(params, [:token])
  end

  defp put_pass_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: password}} ->
        put_change(changeset, :password_hash, Comeonin.Bcrypt.hashpwsalt(password))

      _ ->
        changeset
    end
  end
end
