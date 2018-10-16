defmodule ValiotAppWeb.Schema.ValiotTypes do
  use Absinthe.Schema.Notation
  use Absinthe.Ecto, repo: ValiotApp.Repo
  # Objects

  object :session do
    field(:token, :string)
  end
end
