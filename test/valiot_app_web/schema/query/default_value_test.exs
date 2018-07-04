defmodule ValiotApp.Schema.Query.DefaultValTests do
  use ValiotAppWeb.ConnCase, async: true

  # Change to your corresponding Authorization Bearer token:
  @token "Bearer eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJ2YWxpb3RfYXBwIiwiZXhwIjoxNTMxNDk5NzE4LCJpYXQiOjE1MjkwODA1MTgsImlzcyI6InZhbGlvdF9hcHAiLCJqdGkiOiIyODY4NjVjZi1iN2UzLTQyMjctOWYzNS0xY2ViZGUwOWE1NTQiLCJuYmYiOjE1MjkwODA1MTcsInN1YiI6IjQiLCJ0eXAiOiJhY2Nlc3MifQ.I3PV52s4fdwtdSiIBS8irozcaTzCeFg3smtQp_E7apVvXK0_2Zh2mrtpDGuKt4VgVWmoPN4jlHHEgpUs--iHsw"

  # If you do not need a request header with a token feel free to erase them

  setup do
    Code.eval_string(
      "%ValiotApp.Api.Author{name: \"George\", last_name: \"Williams\", date_of_birth: ~D[1990-01-01]} |> ValiotApp.Repo.insert!()"
    )

    Code.eval_string(
      "_ = %ValiotApp.Api.Author{name: \"Henry\", date_of_birth: ~D[1995-02-01]} |> ValiotApp.Repo.insert!()"
    )

    :ok
  end

  @query """
  {
    authors {
      name
      lastName
    }
  }
  """
  test "Testing default values" do
    conn =
      build_conn()
      |> put_req_header(
        "authorization",
        @token
      )
      |> get("/api", query: @query)

    assert json_response(conn, 200) == %{
             "data" => %{
               "authors" => [
                 %{"name" => "George", "lastName" => "Williams"},
                 %{"name" => "Henry", "lastName" => "null"}
               ]
             }
           }
  end
end