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
          Phoenix.ChannelTest.connect(
            ValiotAppWeb.UserSocket,
            Application.get_env(:valiot_app, :token_helper).header
          )

        {:ok, socket} = Absinthe.Phoenix.SubscriptionTest.join_absinthe(socket)

        {:ok, socket: socket}
      end
    end
  end
end
