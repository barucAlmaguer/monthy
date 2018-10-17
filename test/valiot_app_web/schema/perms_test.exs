defmodule ValiotApp.Schema.Permission do
  use ValiotAppWeb.ConnCase, async: true

  # Change to your corresponding Authorization Bearer token:
  @token Application.get_env(:valiot_app, :token_helper).header.authorization

  # If you do not need a request header with a token feel free to erase them

  setup do
    Code.eval_string(
      "%ValiotApp.Api.Permission{token_id: 1, relation: :permission, create: true} |> ValiotApp.Repo.insert!()"
    )

    :ok
  end

  @mutation """
  mutation {
    createPermission(token_id: 1 relation: PERMISSION read: true) {
      result {
        id
      }
    }
  }
  """

  test "Error when creating a repeated permission." do
    response =
      post(
        build_conn()
        |> put_req_header(
          "authorization",
          @token
        ),
        "/api",
        query: @mutation
      )

    assert %{
             "errors" => [
               %{"message" => message}
             ]
           } = json_response(response, 200)
  end

  @query """
  {
    permissions {
      id
    }
  }
  """

  test "Error when the user does not have permission to perform." do
    response =
      build_conn()
      |> put_req_header(
        "authorization",
        @token
      )
      |> get("/api", query: @query)

    assert %{
             "errors" => [
               %{"message" => message}
             ]
           } = json_response(response, 200)
  end
end
