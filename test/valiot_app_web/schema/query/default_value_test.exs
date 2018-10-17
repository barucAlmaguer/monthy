defmodule ValiotApp.Schema.Query.DefaultValTests do
  use ValiotAppWeb.ConnCase, async: true

  # Change to your corresponding Authorization Bearer token:
  @token Application.get_env(:valiot_app, :token_helper).header.authorization

  # If you do not need a request header with a token feel free to erase them

  setup do
    Code.eval_string(
      "%ValiotApp.Api.Permission{token_id: 1, relation: :author, read: true}  |> ValiotApp.Repo.insert!()"
    )

    Code.eval_string(
      "%ValiotApp.Api.Author{id: 1, name: \"George\", last_name: \"Williams\", date_of_birth: ~D[1990-01-01]} |> ValiotApp.Repo.insert!()"
    )

    :ok
  end

  @query """
  {
    author(id: 1) {
      active
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
               "author" => %{"active" => false}
             }
           }
  end
end
