defmodule ValiotApp.Repo.Migrations.CreateIssues do
  use Ecto.Migration

  def up do
    
    create table(:issues) do
      add(:description, :string)
      add(:name, :string)
      add(:profile_id, references(:profiles, on_delete: :nothing))
      add(:project_id, references(:projects, on_delete: :nothing))
      

      timestamps()
    end
    
    create index(:issues, [:profile_id])
    create index(:issues, [:project_id])
    
  end

  def down do
    drop table(:issues)
    
  end
end
