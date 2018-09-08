defmodule ValiotApp.Schema.Query.HasOneRelationshipTest do
  use ValiotAppWeb.ConnCase, async: true

  @token "Bearer eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJ2YWxpb3RfYXBwIiwiZXhwIjoxNTMxNDk5NzE4LCJpYXQiOjE1MjkwODA1MTgsImlzcyI6InZhbGlvdF9hcHAiLCJqdGkiOiIyODY4NjVjZi1iN2UzLTQyMjctOWYzNS0xY2ViZGUwOWE1NTQiLCJuYmYiOjE1MjkwODA1MTcsInN1YiI6IjQiLCJ0eXAiOiJhY2Nlc3MifQ.I3PV52s4fdwtdSiIBS8irozcaTzCeFg3smtQp_E7apVvXK0_2Zh2mrtpDGuKt4VgVWmoPN4jlHHEgpUs--iHsw"

  setup do
    Code.eval_string(
      "%ValiotApp.Api.Permission{user_id: 4, relation: :author, read: true}  |> ValiotApp.Repo.insert!()"
    )

    Code.eval_string(
      "%ValiotApp.Api.Permission{user_id: 4, relation: :avatar, read: true}  |> ValiotApp.Repo.insert!()"
    )

    Code.eval_string(
      "%ValiotApp.Api.Author{id: 1, name: \"George\", last_name: \"Williams\", date_of_birth: ~D[1990-01-01]} |> ValiotApp.Repo.insert!()"
    )

    Code.eval_string(
      "%ValiotApp.Api.Avatar{id: 1, image_url: \"https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRPUps_P7jflxM8HqqY2J2rzXNbzMiXiVJYteDcBYOk6ua0OO2o\", author_id: 1} |> ValiotApp.Repo.insert!()"
    )

    :ok
  end

  @query """
  {
    avatar(id: 1) {
      author{
        id
      }
    }
  }
  """
  test "1. Get Author id from Avatar" do
    conn =
      build_conn()
      |> put_req_header(
        "authorization",
        @token
      )
      |> get("/api", query: @query)

    assert json_response(conn, 200) == %{
             "data" => %{
               "avatar" => %{"author" => %{"id" => "1"}}
             }
           }
  end

  @query """
  {
    author(id: 1) {
      avatar{
        id
      }
    }
  }
  """
  test "2. Get Avatar id from Author" do
    conn =
      build_conn()
      |> put_req_header(
        "authorization",
        @token
      )
      |> get("/api", query: @query)

    assert json_response(conn, 200) == %{
             "data" => %{
               "author" => %{"avatar" => %{"id" => "1"}}
             }
           }
  end
end
