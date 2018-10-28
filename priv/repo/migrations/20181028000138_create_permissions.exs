defmodule ValiotApp.Repo.Migrations.CreatePermissions do
  use Ecto.Migration

  def up do
    
    RelationEnum.create_type
    create table(:permissions) do
      add(:create, :boolean, default: false)
      add(:delete, :boolean, default: false)
      add(:read, :boolean, default: false)
      add(:relation, :relation)
      add(:token_id, :integer)
      add(:update, :boolean, default: false)
      

      timestamps()
    end
    
    
  end

  def down do
    drop table(:permissions)
    
    RelationEnum.drop_type
  end
end
