defmodule ValiotApp.Repo.Migrations.CreateAreas do
  use Ecto.Migration

  def up do
    
    create table(:areas) do
      add(:name, :string)
      

      timestamps()
    end
    
    
  end

  def down do
    drop table(:areas)
    
  end
end
