defmodule ValiotApp.Api.Issue do
  use Ecto.Schema
  import Ecto.Changeset

  schema "issues" do
    has_many(:areas, ValiotApp.Api.Area)
    field(:description, :string)
    field(:name, :string)
    belongs_to(:profile, ValiotApp.Api.Profile, foreign_key: :profile_id)
    belongs_to(:project, ValiotApp.Api.Project, foreign_key: :project_id)
    

    timestamps()
  end

  @doc false
  def changeset(plan, attrs) do
    plan
    |> cast(attrs, [:description, :name, :profile_id, :project_id, ])
    
    |> validate_required([])
  end
end
