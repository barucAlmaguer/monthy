defmodule ValiotApp.Schema.Subscription.ErrorSubsTest do
  use ValiotAppWeb.SubscriptionCase

  @token Application.get_env(:valiot_app, :token_helper).header.authorization

  # If you do not need a request header with a token feel free to erase them

  setup do
    Code.eval_string(
      "%ValiotApp.Api.Permission{token_id: 1, relation: :author, create: true, update: true, delete: true} |> ValiotApp.Repo.insert!()"
    )

    Code.eval_string(
      "%ValiotApp.Api.Author{id: 6, name: \"Steven\", last_name: \"Williams\", date_of_birth: ~D[1990-01-01]} |> ValiotApp.Repo.insert!()"
    )

    Code.eval_string(
      "_ = %ValiotApp.Api.Author{id: 7, name: \"Peter\", last_name: \"Smith\", date_of_birth: ~D[1995-02-01]} |> ValiotApp.Repo.insert!()"
    )

    :ok
  end

  @subscription """
  subscription {
    authorCreated {
      result {
        name
        lastName
        dateOfBirth
      }
    }
  }
  """
  @mutation """
  mutation {
    createAuthor(name: "Jennifer", lastName: "Jones", dateOfBirth: "1992-01-01") {
      result {
        name
        lastName
        dateOfBirth
      }
    }
  }
  """

  test "1. Subscribe to createAuthor", %{socket: socket} do
    # setup a subscription
    ref = push_doc(socket, @subscription)
    assert_reply(ref, :ok, %{subscriptionId: subscription_id})

    # run a mutation to trigger the subscription
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
                 "result" => %{
                   "dateOfBirth" => "1992-01-01",
                   "lastName" => "Jones",
                   "name" => "Jennifer"
                 }
               }
             }
           }

    # check to see if we got subscription data
    expected = %{
      result: %{
        data: %{
          "authorCreated" => %{
            "result" => %{
              "dateOfBirth" => "1992-01-01",
              "lastName" => "Jones",
              "name" => "Jennifer"
            }
          }
        }
      },
      subscriptionId: subscription_id
    }

    assert_push("subscription:data", push)
    assert expected == push
  end

  @subscription """
  subscription {
    authorUpdated {
      result {
        name
        lastName
        dateOfBirth
        id
      }
    }
  }
  """
  @mutation """
  mutation ($input: UpdateAuthorParams!) {
    updateAuthor(author: $input, id: 6) {
      result {
        name
        lastName
        id
        dateOfBirth
      }
    }
  }
  """
  test "2. Subscribe to updateAuthor", %{socket: socket} do
    # setup a subscription
    ref = push_doc(socket, @subscription)
    assert_reply(ref, :ok, %{subscriptionId: subscription_id})

    # run a mutation to trigger the subscription
    author_input = %{
      "name" => "Liam"
    }

    conn =
      post(
        build_conn()
        |> put_req_header(
          "authorization",
          @token
        ),
        "/api",
        %{query: @mutation, variables: %{"input" => author_input}}
      )

    assert json_response(conn, 200) == %{
             "data" => %{
               "updateAuthor" => %{
                 "result" => %{
                   "dateOfBirth" => "1990-01-01",
                   "id" => "6",
                   "lastName" => "Williams",
                   "name" => "Liam"
                 }
               }
             }
           }

    # check to see if we got subscription data
    expected = %{
      result: %{
        data: %{
          "authorUpdated" => %{
            "result" => %{
              "dateOfBirth" => "1990-01-01",
              "id" => "6",
              "lastName" => "Williams",
              "name" => "Liam"
            }
          }
        }
      },
      subscriptionId: subscription_id
    }

    assert_push("subscription:data", push)
    assert expected == push
  end

  @subscription """
  subscription {
    authorDeleted {
      result {
        name
        lastName
        id
        dateOfBirth
      }
    }
  }
  """
  @mutation """
  mutation {
    deleteAuthor(id: 7) {
      result {
        name
        lastName
        id
        dateOfBirth
      }
    }
  }
  """
  test "3. Subscribe to deleteAuthor", %{socket: socket} do
    # setup a subscription
    ref = push_doc(socket, @subscription)
    assert_reply(ref, :ok, %{subscriptionId: subscription_id})

    # run a mutation to trigger the subscription
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
               "deleteAuthor" => %{
                 "result" => %{
                   "dateOfBirth" => "1995-02-01",
                   "id" => "7",
                   "lastName" => "Smith",
                   "name" => "Peter"
                 }
               }
             }
           }

    # check to see if we got subscription data
    expected = %{
      result: %{
        data: %{
          "authorDeleted" => %{
            "result" => %{
              "dateOfBirth" => "1995-02-01",
              "id" => "7",
              "lastName" => "Smith",
              "name" => "Peter"
            }
          }
        }
      },
      subscriptionId: subscription_id
    }

    assert_push("subscription:data", push)
    assert expected == push
  end
end
