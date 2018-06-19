defmodule ValiotApp.Schema.Query.FiltersTests do
  use ValiotAppWeb.ConnCase, async: true

  # Change to your corresponding Authorization Bearer token:
  @token "Bearer eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJ2YWxpb3RfYXBwIiwiZXhwIjoxNTMxMTg4OTIxLCJpYXQiOjE1Mjg3Njk3MjEsImlzcyI6InZhbGlvdF9hcHAiLCJqdGkiOiJjYTE0NWJlOS1lMGIyLTQzMzgtODgyMy1mNTg2MTRhNmFmZDUiLCJuYmYiOjE1Mjg3Njk3MjAsInN1YiI6IjEiLCJ0eXAiOiJhY2Nlc3MifQ.Asre2h9_r2kArARIFFe4lmdeX8knUF2pXUKKEUZfatzwD1ISOv-8x5Diyr9l86ewclF8MlvW875fOye-2LhWAg"

  # If you do not need a request header with a token feel free to erase them

  setup_all do
    Mix.Tasks.Valiot.Gen.Api.run(["#{File.cwd!()}/schema.graphql"])
    IEx.Helpers.recompile()
    System.cmd("mix", ["ecto.migrate"], env: [{"MIX_ENV", "test"}])
    :ok
  end

  setup do
    Code.eval_string(
      "%ValiotApp.Api.Author{id: 1, last_name: \"Williams\", name: \"George\", date_of_birth: ~D[1990-01-01]} |> ValiotApp.Repo.insert!()"
    )

    Code.eval_string(
      "%ValiotApp.Api.Author{id: 2, last_name: \"Smith\", name: \"Henry\", date_of_birth: ~D[1995-02-01]} |> ValiotApp.Repo.insert!()"
    )

    Code.eval_string(
      "%ValiotApp.Api.Author{id: 3, last_name: \"Jones\", name: \"Rebeca\", date_of_birth: ~D[1999-05-07]} |> ValiotApp.Repo.insert!()"
    )

    Code.eval_string(
      "%ValiotApp.Api.Author{id: 4, last_name: \"Johnson\", name: \"Anna\", date_of_birth: ~D[1980-10-07]} |> ValiotApp.Repo.insert!()"
    )

    Code.eval_string("_ =
      %ValiotApp.Api.Author{id: 5, last_name: \"Johnson\", name: \"Samantha\", date_of_birth: ~D[2000-01-01]}
      |> ValiotApp.Repo.insert!()")
    :ok
  end

  @query """
  {
    authors {
      name
    }
  }
  """
  test "1. Authors names" do
    conn =
      build_conn()
      |> put_req_header(
        "authorization",
        @token
      )
      |> get("/api", query: @query)

    assert json_response(conn, 200) == %{
             "data" => %{
               "authors" => [
                 %{"name" => "George"},
                 %{"name" => "Henry"},
                 %{"name" => "Rebeca"},
                 %{"name" => "Anna"},
                 %{"name" => "Samantha"}
               ]
             }
           }
  end

  @query """
  {
    authors(filter: {name: "Rebeca"}) {
      name
    }
  }
  """
  test "2. Authors filtered by name: Rebeca " do
    response =
      build_conn()
      |> put_req_header(
        "authorization",
        @token
      )
      |> get("/api", query: @query)

    assert json_response(response, 200) == %{
             "data" => %{
               "authors" => [
                 %{"name" => "Rebeca"}
               ]
             }
           }
  end

  @query """
  {
    authors(filter: {name: 123}) {
      name
    }
  }
  """
  test "3. Authors error output when filter value is invalid, name: 123" do
    response =
      build_conn()
      |> put_req_header(
        "authorization",
        @token
      )
      |> get("/api", query: @query)

    assert %{
             "errors" => [
               %{"message" => message}
             ]
           } = json_response(response, 400)

    assert message ==
             "Argument \"filter\" has invalid value {name: 123}.\nIn field \"name\": Expected type \"String\", found 123."
  end

  @query """
  query ($term: String) {
    authors(filter: {name: $term}) {
      name
      dateOfBirth
    }
  }
  """
  @variables %{"term" => "George"}
  test "4. Authors field filtered by name when using a variable $term" do
    response =
      build_conn()
      |> put_req_header(
        "authorization",
        @token
      )
      |> get("/api", query: @query, variables: @variables)

    assert json_response(response, 200) == %{
             "data" => %{
               "authors" => [
                 %{"name" => "George", "dateOfBirth" => "1990-01-01"}
               ]
             }
           }
  end

  @query """
  query ($term: String) {
    authors(filter: {name: $term}) {
      name
    }
  }
  """
  @variables %{"term" => 1}
  test "5. Authors field returns an error when using a bad variable value" do
    response =
      build_conn()
      |> put_req_header(
        "authorization",
        @token
      )
      |> get("/api", query: @query, variables: @variables)

    assert %{"errors" => _} = json_response(response, 400)
  end

  @query """
  query ($term: String) {
    authors(filter: {last_name: $term}) {
      name
      dateOfBirth
      lastName
    }
  }
  """
  @variables %{"term" => "Williams"}
  test "6. Authors field returns values when using lastName variable value" do
    response =
      build_conn()
      |> put_req_header(
        "authorization",
        @token
      )
      |> get("/api", query: @query, variables: @variables)

    assert json_response(response, 200) == %{
             "data" => %{
               "authors" => [
                 %{"name" => "George", "dateOfBirth" => "1990-01-01", "lastName" => "Williams"}
               ]
             }
           }
  end

  @query """
  query ($term: Date) {
    authors(filter: {date_of_birth: $term}) {
      lastName
      dateOfBirth
    }
  }
  """
  @variables %{"term" => "1990-01-01"}
  test "7. Authors filter by date_of_birth" do
    response =
      build_conn()
      |> put_req_header(
        "authorization",
        @token
      )
      |> get("/api", query: @query, variables: @variables)

    assert json_response(response, 200) == %{
             "data" => %{
               "authors" => [
                 %{"dateOfBirth" => "1990-01-01", "lastName" => "Williams"}
               ]
             }
           }
  end

  @query """
  query ($term: Int) {
    authors(filter: {id: $term}) {
      lastName
      dateOfBirth
    }
  }
  """
  @variables %{"term" => 1}
  test "8. Authors filter by ID" do
    response =
      build_conn()
      |> put_req_header(
        "authorization",
        @token
      )
      |> get("/api", query: @query, variables: @variables)

    assert json_response(response, 200) == %{
             "data" => %{
               "authors" => [
                 %{"dateOfBirth" => "1990-01-01", "lastName" => "Williams"}
               ]
             }
           }
  end
end
