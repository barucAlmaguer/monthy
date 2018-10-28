defmodule ValiotApp.Repo.Migrations.CreateProjects do
  use Ecto.Migration

  def up do
    
    create table(:projects) do
      add(:description, :string)
      add(:name, :string)
      add(:tag, :string)
      

      timestamps()
    end
    
    
  end

  def down do
    drop table(:projects)
    
  end
end
