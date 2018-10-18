defmodule ValiotApp.Schema.Query.BelongsToIdTests do
  use ValiotAppWeb.ConnCase, async: true

  @token Application.get_env(:valiot_app, :token_helper).header.authorization

  setup do
    Code.eval_string(
      "%ValiotApp.Api.Permission{token_id: 1, relation: :author, read: true}  |> ValiotApp.Repo.insert!()"
    )

    Code.eval_string(
      "%ValiotApp.Api.Permission{token_id: 1, relation: :blog_post, read: true}  |> ValiotApp.Repo.insert!()"
    )

    Code.eval_string(
      "%ValiotApp.Api.Author{id: 1, name: \"George\", last_name: \"Williams\", date_of_birth: ~D[1990-01-01]} |> ValiotApp.Repo.insert!()"
    )

    Code.eval_string(
      "%ValiotApp.Api.BlogPost{id: 1, name: \"Test Blog Post\", body: \"Test body\", author_id: 1} |> ValiotApp.Repo.insert!()"
    )

    :ok
  end

  @query """
  {
    blog_post(id: 1) {
      author_id
    }
  }
  """
  test "1. Author id" do
    conn =
      build_conn()
      |> put_req_header(
        "authorization",
        @token
      )
      |> get("/api", query: @query)

    assert json_response(conn, 200) == %{
             "data" => %{
               "blog_post" => %{"author_id" => "1"}
             }
           }
  end
end
