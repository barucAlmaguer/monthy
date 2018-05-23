defmodule ValiotAppWeb.Schema.ValiotTypes do
  use Absinthe.Schema.Notation
  use Absinthe.Ecto, repo: ValiotApp.ValiotRepo
  # Objects

  object :user do
    field(:id, :id)
    field(:name, :string)
    field(:last_name, :string)
    field(:email, :string)
    field(:password, :string)
  end

  object :session do
    field(:token, :string)
  end
end
