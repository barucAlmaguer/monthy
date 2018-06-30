defmodule ValiotApp.Schema.Subscription.ErrorSubsTest do
  use ValiotAppWeb.SubscriptionCase

  # Change to your corresponding Authorization Bearer token:
  @token "Bearer eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJ2YWxpb3RfYXBwIiwiZXhwIjoxNTMxMTg4OTIxLCJpYXQiOjE1Mjg3Njk3MjEsImlzcyI6InZhbGlvdF9hcHAiLCJqdGkiOiJjYTE0NWJlOS1lMGIyLTQzMzgtODgyMy1mNTg2MTRhNmFmZDUiLCJuYmYiOjE1Mjg3Njk3MjAsInN1YiI6IjEiLCJ0eXAiOiJhY2Nlc3MifQ.Asre2h9_r2kArARIFFe4lmdeX8knUF2pXUKKEUZfatzwD1ISOv-8x5Diyr9l86ewclF8MlvW875fOye-2LhWAg"

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

    ref = push_doc(socket, @mutation)
    assert_reply(ref, :ok, reply)

    assert %{
             data: %{
               "createAuthor" => %{
                 "dateOfBirth" => "1992-01-01",
                 "lastName" => "Jones",
                 "name" => "Jennifer"
               }
             }
           } = reply

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

    ref = push_doc(socket, @mutation, variables: %{"input" => author_input})
    assert_reply(ref, :ok, reply)

    assert %{
             data: %{
               "updateAuthor" => %{
                 "dateOfBirth" => "1990-01-01",
                 "id" => "6",
                 "lastName" => "Williams",
                 "name" => "Liam"
               }
             }
           } = reply

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

    ref = push_doc(socket, @mutation)
    assert_reply(ref, :ok, reply)

    assert %{
             data: %{
               "deleteAuthor" => %{
                 "dateOfBirth" => "1995-02-01",
                 "id" => "7",
                 "lastName" => "Smith",
                 "name" => "Peter"
               }
             }
           } = reply

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
