defmodule ValiotApp.Schema.Mutations.UniqueTests do
  use ValiotAppWeb.ConnCase, async: true

  # Change to your corresponding Authorization Bearer token:
  @token Application.get_env(:valiot_app, :token_helper).header.authorization

  # If you do not need a request header with a token feel free to erase them

  setup do
    Code.eval_string(
      "%ValiotApp.Api.Permission{token_id: 1, relation: :author, read: true, create: true}  |> ValiotApp.Repo.insert!()"
    )

    Code.eval_string(
      "%ValiotApp.Api.Author{name: \"George\", last_name: \"Williams\", date_of_birth: ~D[1990-01-01]} |> ValiotApp.Repo.insert!()"
    )

    :ok
  end

  @mutation """
  mutation {
    createAuthor(name: "George", lastName: "Williams") {
      result {
        id
      }
      successful
      messages {
        field
        message
      }
    }
  }
  """
  test "Testing unique values" do
    conn =
      post(
        build_conn()
        |> put_req_header(
          "authorization",
          @token
        ),
        "/api",
        query: @mutation
      )

    assert json_response(conn, 200) == %{
             "data" => %{
               "createAuthor" => %{
                 "result" => nil,
                 "successful" => false,
                 "messages" => [
                   %{
                     "field" => "name",
                     "message" => "must be unique"
                   }
                 ]
               }
             }
           }
  end
end
