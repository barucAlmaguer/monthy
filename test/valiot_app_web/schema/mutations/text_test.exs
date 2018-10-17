defmodule ValiotApp.Schema.Mutations.TextTests do
  use ValiotAppWeb.ConnCase, async: true

  # Change to your corresponding Authorization Bearer token:
  @token Application.get_env(:valiot_app, :token_helper).header.authorization

  # If you do not need a request header with a token feel free to erase them

  setup do
    Code.eval_string(
      "%ValiotApp.Api.Permission{token_id: 1, relation: :author, read: true, create: true}  |> ValiotApp.Repo.insert!()"
    )

    Code.eval_string(
      "%ValiotApp.Api.Permission{token_id: 1, relation: :blog_post, read: true, create: true}  |> ValiotApp.Repo.insert!()"
    )

    Code.eval_string(
      "%ValiotApp.Api.Author{id: 1, name: \"George\", last_name: \"Williams\", date_of_birth: ~D[1990-01-01]} |> ValiotApp.Repo.insert!()"
    )

    :ok
  end

  @mutation """
  mutation {
    createBlogPost(name: "Test", body: "Lorem ipsum dolor sit amet consectetur adipiscing elit fermentum, pulvinar platea sodales conubia curae vivamus eros, convallis porta quam facilisis at pretium in. Nisl luctus nec phasellus leo vehicula feugiat gravida iaculis suspendisse non rutrum sem integer enim.", authorId: 1) {
      successful
    }
  }
  """
  test "Testing text field" do
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
               "createBlogPost" => %{
                 "successful" => true
               }
             }
           }
  end
end
