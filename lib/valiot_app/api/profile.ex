defmodule ValiotApp.Api.Profile do
  use Ecto.Schema
  import Ecto.Changeset

  schema "profiles" do
    has_many(:areas, ValiotApp.Api.Area)
    field(:description, :string)
    field(:main, :string)
    field(:name, :string)
    field(:picture, :string)
    has_many(:projects, ValiotApp.Api.Project)
    

    timestamps()
  end

  @doc false
  def changeset(plan, attrs) do
    plan
    |> cast(attrs, [:description, :main, :name, :picture, ])
    
    |> validate_required([])
  end
end
