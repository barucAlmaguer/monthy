defmodule ValiotApp.Schema.Query.UniqueTests do
  use ValiotAppWeb.ConnCase, async: true

  # Change to your corresponding Authorization Bearer token:
  @token "Bearer eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJ2YWxpb3RfYXBwIiwiZXhwIjoxNTMxNDk5NzE4LCJpYXQiOjE1MjkwODA1MTgsImlzcyI6InZhbGlvdF9hcHAiLCJqdGkiOiIyODY4NjVjZi1iN2UzLTQyMjctOWYzNS0xY2ViZGUwOWE1NTQiLCJuYmYiOjE1MjkwODA1MTcsInN1YiI6IjQiLCJ0eXAiOiJhY2Nlc3MifQ.I3PV52s4fdwtdSiIBS8irozcaTzCeFg3smtQp_E7apVvXK0_2Zh2mrtpDGuKt4VgVWmoPN4jlHHEgpUs--iHsw"

  # If you do not need a request header with a token feel free to erase them

  setup do
    Code.eval_string(
      "%ValiotApp.Api.Permission{user_id: 4, relation: :author, read: true}  |> ValiotApp.Repo.insert!()"
    )

    Code.eval_string(
      "%ValiotApp.Api.Author{id: 1, name: \"George\", last_name: \"Williams\", date_of_birth: ~D[1990-01-01]} |> ValiotApp.Repo.insert!()"
    )

    Code.eval_string(
      "ValiotApp.Api.create_post(%{name: \"Testing\", body: \"This is a test\", author_id: 1})"
    )

    :ok
  end

  @mutation """
  {
    createPost(author_id: 1, name: "Testing", body: "This is a test") {
      id
    }
  }
  """
  test "Testing unique values" do
    response =
      build_conn()
      |> put_req_header(
        "authorization",
        @token
      )
      |> get("/api", mutation: @mutation)

    assert %{
             "errors" => [
               %{"message" => message}
             ]
           } = json_response(response, 400)

    assert message == "illegal: --"
  end
end
