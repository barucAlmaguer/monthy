defmodule ValiotApp.Schema.Query.DefaultValTests do
  use ValiotAppWeb.ConnCase, async: true

  # Change to your corresponding Authorization Bearer token:
  @token "Bearer eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJ2YWxpb3RfYXBwIiwiZXhwIjoxNTMxMTg4OTIxLCJpYXQiOjE1Mjg3Njk3MjEsImlzcyI6InZhbGlvdF9hcHAiLCJqdGkiOiJjYTE0NWJlOS1lMGIyLTQzMzgtODgyMy1mNTg2MTRhNmFmZDUiLCJuYmYiOjE1Mjg3Njk3MjAsInN1YiI6IjEiLCJ0eXAiOiJhY2Nlc3MifQ.Asre2h9_r2kArARIFFe4lmdeX8knUF2pXUKKEUZfatzwD1ISOv-8x5Diyr9l86ewclF8MlvW875fOye-2LhWAg"

  # If you do not need a request header with a token feel free to erase them

  setup_all do
    Mix.Tasks.Valiot.Gen.Api.run(["#{File.cwd!()}/schema.graphql"])
    IEx.Helpers.recompile()
    System.cmd("mix", ["ecto.migrate"], env: [{"MIX_ENV", "test"}])
    :ok
  end

  setup do
    Code.eval_string(
      "%ValiotApp.Api.Author{id: 1, name: \"George\", last_name: \"Williams\", date_of_birth: ~D[1990-01-01]} |> ValiotApp.Repo.insert!()"
    )

    Code.eval_string(
      "_ = %ValiotApp.Api.Author{id: 2, name: \"Henry\", date_of_birth: ~D[1995-02-01]} |> ValiotApp.Repo.insert!()"
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
