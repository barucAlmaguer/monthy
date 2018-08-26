defmodule ValiotAppWeb.SubscriptionCase do
  @moduledoc """
  This module defines the test case to be used by
  subscription tests
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      # Import conveniences for testing with channels
      use ValiotAppWeb.ChannelCase
      use Absinthe.Phoenix.SubscriptionTest, schema: ValiotAppWeb.Schema
      use Phoenix.ConnTest

      setup do
        {:ok, socket} =
          Phoenix.ChannelTest.connect(ValiotAppWeb.UserSocket, %{
            "Authorization" =>
              "Bearer eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJ2YWxpb3RfYXBwIiwiZXhwIjoxNTMxNDk5NzE4LCJpYXQiOjE1MjkwODA1MTgsImlzcyI6InZhbGlvdF9hcHAiLCJqdGkiOiIyODY4NjVjZi1iN2UzLTQyMjctOWYzNS0xY2ViZGUwOWE1NTQiLCJuYmYiOjE1MjkwODA1MTcsInN1YiI6IjQiLCJ0eXAiOiJhY2Nlc3MifQ.I3PV52s4fdwtdSiIBS8irozcaTzCeFg3smtQp_E7apVvXK0_2Zh2mrtpDGuKt4VgVWmoPN4jlHHEgpUs--iHsw"
          })

        {:ok, socket} = Absinthe.Phoenix.SubscriptionTest.join_absinthe(socket)

        {:ok, socket: socket}
      end
    end
  end
end
