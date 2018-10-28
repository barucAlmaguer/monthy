defmodule ValiotApp.Repo.Migrations.CreateAreaIssues do
  use Ecto.Migration

  def up do
    
    create table(:area_issues) do
      add(:area_id, references(:areas, on_delete: :nothing))
      add(:issue_id, references(:issues, on_delete: :nothing))
      

      timestamps()
    end
    
    create index(:area_issues, [:area_id])
    create index(:area_issues, [:issue_id])
    
  end

  def down do
    drop table(:area_issues)
    
  end
end
