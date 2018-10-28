defmodule ValiotApp.Api.AreaIssue do
  use Ecto.Schema
  import Ecto.Changeset

  schema "area_issues" do
    belongs_to(:area, ValiotApp.Api.Area, foreign_key: :area_id)
    belongs_to(:issue, ValiotApp.Api.Issue, foreign_key: :issue_id)
    

    timestamps()
  end

  @doc false
  def changeset(plan, attrs) do
    plan
    |> cast(attrs, [:area_id, :issue_id, ])
    
    |> validate_required([])
  end
end
