defmodule ValiotApp.Api.Area do
  use Ecto.Schema
  import Ecto.Changeset

  schema "areas" do
    has_many(:issues, ValiotApp.Api.Issue)
    field(:name, :string)
    has_many(:profiles, ValiotApp.Api.Profile)
    has_many(:projects, ValiotApp.Api.Project)
    

    timestamps()
  end

  @doc false
  def changeset(plan, attrs) do
    plan
    |> cast(attrs, [:name, ])
    
    |> validate_required([:name])
  end
end
