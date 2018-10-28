defmodule ValiotApp.Repo.Migrations.CreateRoles do
  use Ecto.Migration

  def up do
    
    create table(:roles) do
      add(:name, :string)
      

      timestamps()
    end
    
    
  end

  def down do
    drop table(:roles)
    
  end
end
