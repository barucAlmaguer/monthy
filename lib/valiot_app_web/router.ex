defmodule ValiotAppWeb.Router do
  use ValiotAppWeb, :router

  pipeline :graphql do
    plug(ValiotAppWeb.Context)
  end

  scope "/api" do
    pipe_through(:graphql)

    forward(
      "/graphiql",
      Absinthe.Plug.GraphiQL,
      schema: ValiotAppWeb.Schema,
      socket: ValiotAppWeb.UserSocket
    )

    forward("/", Absinthe.Plug, schema: ValiotAppWeb.Schema, json_codec: Jason)
  end
end
