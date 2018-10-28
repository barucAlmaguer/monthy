defmodule ValiotApp.Repo.Migrations.CreateProjectProfiles do
  use Ecto.Migration

  def up do
    
    create table(:project_profiles) do
      add(:profile_id, references(:profiles, on_delete: :nothing))
      add(:project_id, references(:projects, on_delete: :nothing))
      add(:role_id, references(:roles, on_delete: :nothing))
      

      timestamps()
    end
    
    create index(:project_profiles, [:profile_id])
    create index(:project_profiles, [:project_id])
    create index(:project_profiles, [:role_id])
    
  end

  def down do
    drop table(:project_profiles)
    
  end
end
