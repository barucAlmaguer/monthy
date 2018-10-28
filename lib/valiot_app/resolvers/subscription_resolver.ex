defmodule ValiotApp.SubscriptionResolver do
  def subscribe(item, _, %{context: %{current_user: _current_user}}) do
    {:ok, item}
  end

  def subscribe(_args, _info, _ctx) do
    {:error, "Not Authorized"}
  end
end
