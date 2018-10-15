defmodule ValiotAppWeb.TokenHelper do
  @moduledoc false
  @url Application.get_env(:valiot_app, :token_helper).url
  @header Application.get_env(:valiot_app, :token_helper).header

  def authorize_token(token) do
    body = "{
      authorizeToken(token: \"#{token}\"){
        result{
          valid
          id
        }
      }
    }"
    {:ok, response} = HTTPoison.post(@url, body, @header)
    {:ok, result} = Jason.decode(response.body)
    {:ok, parse_result("authorizeToken", result)}
  end

  def create_token() do
    body = "mutation{
      createToken{
        result{
          token
          id
        }
      }
    }"
    {:ok, response} = HTTPoison.post(@url, body, @header)
    {:ok, result} = Jason.decode(response.body)
    {:ok, parse_result("createToken", result)}
  end

  def clear_token(id) do
    body = "mutation{
      clearToken(id: #{id}){
        result{
          id
        }
      }
    }"
    {:ok, response} = HTTPoison.post(@url, body, @header)
    {:ok, result} = Jason.decode(response.body)
    {:ok, parse_result("clearToken", result)}
  end

  def update_token(id) do
    body = "mutation{
      updateToken(id: #{id}){
        result{
          token
          id
        }
      }"
    {:ok, response} = HTTPoison.post(@url, body, @header)
    {:ok, result} = Jason.decode(response.body)
    {:ok, parse_result("updateToken", result)}
  end

  defp parse_result(field, response) do
    response["data"][field]["result"]
  end
end
