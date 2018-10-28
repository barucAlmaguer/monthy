defmodule ValiotApp.Api.Permission do
  use Ecto.Schema
  import Ecto.Changeset

  schema "permissions" do
    field(:create, :boolean)
    field(:delete, :boolean)
    field(:read, :boolean)
    field(:relation, RelationEnum)
    field(:token_id, :integer)
    field(:update, :boolean)
    

    timestamps()
  end

  @doc false
  def changeset(plan, attrs) do
    plan
    |> cast(attrs, [:create, :delete, :read, :relation, :token_id, :update, ])
    
    |> validate_required([:relation, :token_id])
  end
end
