defmodule ValiotApp.Repo.Migrations.CreateProfiles do
  use Ecto.Migration

  def up do
    
    create table(:profiles) do
      add(:description, :string)
      add(:main, :string)
      add(:name, :string)
      add(:picture, :string)
      

      timestamps()
    end
    
    
  end

  def down do
    drop table(:profiles)
    
  end
end
