defmodule ValiotApp.Schema.Subscription.ErrorSubsTest do
  use ValiotAppWeb.SubscriptionCase

  # Change to your corresponding Authorization Bearer token:
  @token "Bearer eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJ2YWxpb3RfYXBwIiwiZXhwIjoxNTMxNDk5NzE4LCJpYXQiOjE1MjkwODA1MTgsImlzcyI6InZhbGlvdF9hcHAiLCJqdGkiOiIyODY4NjVjZi1iN2UzLTQyMjctOWYzNS0xY2ViZGUwOWE1NTQiLCJuYmYiOjE1MjkwODA1MTcsInN1YiI6IjQiLCJ0eXAiOiJhY2Nlc3MifQ.I3PV52s4fdwtdSiIBS8irozcaTzCeFg3smtQp_E7apVvXK0_2Zh2mrtpDGuKt4VgVWmoPN4jlHHEgpUs--iHsw"

  # If you do not need a request header with a token feel free to erase them

  setup do
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
    createAuthor {
      name
      lastName
      dateOfBirth
    }
  }
  """
  @mutation """
  mutation {
    createAuthor(name: "Jennifer", lastName: "Jones", dateOfBirth: "1992-01-01") {
      name
      lastName
      dateOfBirth
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
                 "dateOfBirth" => "1992-01-01",
                 "lastName" => "Jones",
                 "name" => "Jennifer"
               }
             }
           }

    # check to see if we got subscription data
    expected = %{
      result: %{
        data: %{
          "createAuthor" => %{
            "dateOfBirth" => "1992-01-01",
            "lastName" => "Jones",
            "name" => "Jennifer"
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
    updateAuthor {
      name
      lastName
      dateOfBirth
      id
    }
  }
  """
  @mutation """
  mutation ($input: UpdateAuthorParams!) {
    updateAuthor(author: $input, id: 6) {
      name
      lastName
      id
      dateOfBirth
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
                 "dateOfBirth" => "1990-01-01",
                 "id" => "6",
                 "lastName" => "Williams",
                 "name" => "Liam"
               }
             }
           }

    # check to see if we got subscription data
    expected = %{
      result: %{
        data: %{
          "updateAuthor" => %{
            "dateOfBirth" => "1990-01-01",
            "id" => "6",
            "lastName" => "Williams",
            "name" => "Liam"
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
    deleteAuthor {
      name
      lastName
      id
      dateOfBirth
    }
  }
  """
  @mutation """
  mutation {
    deleteAuthor(id: 7) {
      name
      lastName
      id
      dateOfBirth
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
                 "dateOfBirth" => "1995-02-01",
                 "id" => "7",
                 "lastName" => "Smith",
                 "name" => "Peter"
               }
             }
           }

    # check to see if we got subscription data
    expected = %{
      result: %{
        data: %{
          "deleteAuthor" => %{
            "dateOfBirth" => "1995-02-01",
            "id" => "7",
            "lastName" => "Smith",
            "name" => "Peter"
          }
        }
      },
      subscriptionId: subscription_id
    }

    assert_push("subscription:data", push)
    assert expected == push
  end
end
