defmodule ValiotAppWeb.Context do
  @behaviour Plug

  import Plug.Conn
  import Ecto.Query, only: [where: 2]

  def init(opts), do: opts

  def call(conn, _) do
    case build_context(conn) do
      {:ok, context} ->
        put_private(conn, :absinthe, %{context: context})

      _ ->
        conn
    end
  end

  defp build_context(conn) do
    with ["Bearer " <> token] <- get_req_header(conn, "authorization"),
         {:ok, current_token} <- authorize(token) do
      {:ok, %{current_token: current_token, token: token}}
    end
  end

  defp authorize(token) do
    ValiotAppWeb.TokenHelper.authorize_token(token)
    |> case do
      {:ok, %{"valid" => false}} ->
        {:error, "Invalid authorization token"}

      {:ok, %{"valid" => true, "id" => id}} ->
        {:ok, %{token: token, id: id}}
    end
  end
end
