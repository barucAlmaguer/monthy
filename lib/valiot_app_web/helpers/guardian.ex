defmodule ValiotAppWeb.Guardian do
  use Guardian, otp_app: :valiot_app
  alias ValiotApp.Api

  def subject_for_token(user, _claims) do
    sub = to_string(user.id)
    {:ok, sub}
  end

  def resource_from_claims(claims) do
    user =
      claims["sub"]
      |> Api.get_user!()

    {:ok, user}
  end
end
