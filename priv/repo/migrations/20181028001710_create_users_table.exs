defmodule ValiotApp.Repo.Migrations.CreateUsersTable do
  use Ecto.Migration

  def up do

    create table(:users) do
      add(:email, :string)
      add(:password, :string, virtual: true)
      add(:password_hash, :string)
      add(:token, :string)

      timestamps()
    end


  end

  def down do
    drop table(:profiles)

  end
end
