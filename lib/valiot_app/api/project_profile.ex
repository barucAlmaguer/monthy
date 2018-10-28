defmodule ValiotApp.Api.ProjectProfile do
  use Ecto.Schema
  import Ecto.Changeset

  schema "project_profiles" do
    belongs_to(:profile, ValiotApp.Api.Profile, foreign_key: :profile_id)
    belongs_to(:project, ValiotApp.Api.Project, foreign_key: :project_id)
    belongs_to(:role, ValiotApp.Api.Role, foreign_key: :role_id)
    

    timestamps()
  end

  @doc false
  def changeset(plan, attrs) do
    plan
    |> cast(attrs, [:profile_id, :project_id, :role_id, ])
    
    |> validate_required([])
  end
end
