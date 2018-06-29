defmodule ValiotApp.Schema.Subscription.ErrorSubsTest do
  use ValiotAppWeb.SubscriptionCase

  # Change to your corresponding Authorization Bearer token:
  @token "Bearer eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJ2YWxpb3RfYXBwIiwiZXhwIjoxNTMxMTg4OTIxLCJpYXQiOjE1Mjg3Njk3MjEsImlzcyI6InZhbGlvdF9hcHAiLCJqdGkiOiJjYTE0NWJlOS1lMGIyLTQzMzgtODgyMy1mNTg2MTRhNmFmZDUiLCJuYmYiOjE1Mjg3Njk3MjAsInN1YiI6IjEiLCJ0eXAiOiJhY2Nlc3MifQ.Asre2h9_r2kArARIFFe4lmdeX8knUF2pXUKKEUZfatzwD1ISOv-8x5Diyr9l86ewclF8MlvW875fOye-2LhWAg"

  # If you do not need a request header with a token feel free to erase them

  setup do
    Code.eval_string(
      "%ValiotApp.Api.Author{id: 1, name: \"George\", last_name: \"Williams\", date_of_birth: ~D[1990-01-01]} |> ValiotApp.Repo.insert!()"
    )

    Code.eval_string(
      "_ = %ValiotApp.Api.Author{id: 2, name: \"Henry\", last_name: \"Smith\", date_of_birth: ~D[1995-02-01]} |> ValiotApp.Repo.insert!()"
    )

    :ok
  end

  @subscription """
  subscription {
    createAuthor {
      name
      id
    }
  }
  """
  @mutation """
  mutation {
    createAuthor(name: "Jennifer", lastName: "Jones", dateOfBirth: "1992-01-01") {
      name
      lastName
      dateOfBirth
      id
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
                 "author" => %{
                   "id" => 3,
                   "name" => "Jennifer",
                   "lastName" => "Jones",
                   "dateOfBirth" => "1992-01-01"
                 }
               }
             }
           } = reply

    # check to see if we got subscription data
    expected = %{
      result: %{data: %{"createAuthor" => %{"name" => "Jennifer", "id" => 3}}},
      subscriptionId: subscription_id
    }

    assert_push("subscription:data", push)
    assert expected == push
  end

  @subscription """
  subscription {
    updateAuthor {
      name
      id
    }
  }
  """
  @mutation """
  mutation ($input: UpdateAuthorParams!) {
    updateAuthor(author: $input, id: 1) {
      name
      lastName
      id
    }
  }
  """
  test "2. Subscribe to updateAuthor", %{socket: socket} do
    # setup a subscription
    ref = push_doc(socket, @subscription)
    assert_reply(ref, :ok, %{subscriptionId: subscription_id})

    # run a mutation to trigger the subscription
    author_input = %{
      "name" => "Charles"
    }

    ref = push_doc(socket, @mutation, variables: %{"input" => author_input})
    assert_reply(ref, :ok, reply)
    assert %{data: %{"updateAuthor" => %{"name" => "Charles", "lastName" => "Williams", "id" => 1}}} = reply

    # check to see if we got subscription data
    expected = %{
      result: %{data: %{"updateAuthor" => %{"name" => "Charles", "id" => 1}}},
      subscriptionId: subscription_id
    }

    assert_push("subscription:data", push)
    assert expected == push
  end

  @subscription """
  subscription {
    deleteAuthor {
      name
      id
    }
  }
  """
  @mutation """
  mutation {
    deleteAuthor(id: 2) {
      name
      lastName
      id
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
    assert %{data: %{"deleteAuthor" => %{"name" => "Henry", "lastName" => "Smith", "id" => 2}}} = reply

    # check to see if we got subscription data
    expected = %{
      result: %{data: %{"deleteAuthor" => %{"name" => "Henry", "id" => 2}}},
      subscriptionId: subscription_id
    }

    assert_push("subscription:data", push)
    assert expected == push
  end
end
