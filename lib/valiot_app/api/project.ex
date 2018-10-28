defmodule ValiotApp.Api.Project do
  use Ecto.Schema
  import Ecto.Changeset

  schema "projects" do
    has_many(:areas, ValiotApp.Api.Area)
    field(:description, :string)
    has_many(:issues, ValiotApp.Api.Issue)
    field(:name, :string)
    field(:tag, :string)
    

    timestamps()
  end

  @doc false
  def changeset(plan, attrs) do
    plan
    |> cast(attrs, [:description, :name, :tag, ])
    
    |> validate_required([])
  end
end
