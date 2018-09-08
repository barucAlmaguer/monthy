defmodule ValiotApp.Schema.Query.FiltersTests do
  use ValiotAppWeb.ConnCase, async: true

  # Change to your corresponding Authorization Bearer token:
  @token "Bearer eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJ2YWxpb3RfYXBwIiwiZXhwIjoxNTMxNDk5NzE4LCJpYXQiOjE1MjkwODA1MTgsImlzcyI6InZhbGlvdF9hcHAiLCJqdGkiOiIyODY4NjVjZi1iN2UzLTQyMjctOWYzNS0xY2ViZGUwOWE1NTQiLCJuYmYiOjE1MjkwODA1MTcsInN1YiI6IjQiLCJ0eXAiOiJhY2Nlc3MifQ.I3PV52s4fdwtdSiIBS8irozcaTzCeFg3smtQp_E7apVvXK0_2Zh2mrtpDGuKt4VgVWmoPN4jlHHEgpUs--iHsw"

  # If you do not need a request header with a token feel free to erase them

  setup do
    Code.eval_string(
      "%ValiotApp.Api.Permission{user_id: 4, relation: :author, read: true} |> ValiotApp.Repo.insert!()"
    )

    Code.eval_string(
      "%ValiotApp.Api.Permission{user_id: 4, relation: :comment, read: true} |> ValiotApp.Repo.insert!()"
    )

    Code.eval_string(
      "%ValiotApp.Api.Permission{user_id: 4, relation: :post, read: true} |> ValiotApp.Repo.insert!()"
    )

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

    Code.eval_string("%ValiotApp.Api.Comment{
        author_id: 1,
        body: \"heyy\",
        id: 1,
        inserted_at: ~N[2018-07-11 23:08:17.345950],
        updated_at: ~N[2018-07-11 23:08:17.345957]
      }|> ValiotApp.Repo.insert!()")
    Code.eval_string("%ValiotApp.Api.Comment{
        author_id: 1,
        body: \"how are you\",
        id: 2,
        inserted_at: ~N[2018-07-11 23:08:17.345950],
        updated_at: ~N[2018-07-11 23:08:17.345957]
      }|> ValiotApp.Repo.insert!()")

    Code.eval_string("%ValiotApp.Api.Post{
          body: \"how are you\",
          name: \"pedro\",
          status_word: :pending,
        }|> ValiotApp.Repo.insert!()")

    Code.eval_string(
      "%ValiotApp.Api.Author{id: 5, active: true, last_name: \"Johnson\", name: \"Samantha\", date_of_birth: ~D[2000-01-01]}
      |> ValiotApp.Repo.insert!()"
    )

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
    authors(filter: {name: "beca"}) {
      name
    }
  }
  """
  test "2. Authors filtered by name: beca " do
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
  {
    authors(filter: {active: true}) {
      name
    }
  }
  """
  test "8. Authors filter by Boolean" do
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
                 %{"name" => "Samantha"}
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
  test "9. Authors filter by ID" do
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
  query ($after: DateTime!) {
    authors(filter: {after: $after}) {
      name
    }
  }
  """
  @variables %{"after" => "2018-07-03T15:52:11.330Z"}
  test "10. Authors filter after" do
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
  query ($term: Int) {
    author(id: $term) {
      comments(filter:{id:$term}){
        id
      }
    }
  }
  """
  @variables %{"term" => 1}
  test "11. Authors with many assoc in comments" do
    response =
      build_conn()
      |> put_req_header(
        "authorization",
        @token
      )
      |> get("/api", query: @query, variables: @variables)

    assert json_response(response, 200) == %{
             "data" => %{
               "author" => %{
                 "comments" => [
                   %{"id" => "1"}
                 ]
               }
             }
           }
  end

  @query """
  {
    authors(orderBy:{desc: ID}) {
      id
    }
  }
  """
  test "12. Authors order desc by id" do
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
                 %{"id" => "5"},
                 %{"id" => "4"},
                 %{"id" => "3"},
                 %{"id" => "2"},
                 %{"id" => "1"}
               ]
             }
           }
  end

  @query """
  {
    authors(orderBy:{desc: INSERTED_AT}) {
      id
    }
  }
  """
  test "13. Authors order desc by inserted_at " do
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
                 %{"id" => "5"},
                 %{"id" => "4"},
                 %{"id" => "3"},
                 %{"id" => "2"},
                 %{"id" => "1"}
               ]
             }
           }
  end

  @query """
  {
    posts(filter:{status_word:PENDING}) {
      statusWord
    }
  }
  """
  test "14. Posts with enum " do
    response =
      build_conn()
      |> put_req_header(
        "authorization",
        @token
      )
      |> get("/api", query: @query)

    assert json_response(response, 200) == %{
             "data" => %{
               "posts" => [
                 %{"statusWord" => "PENDING"}
               ]
             }
           }
  end

  @query """
  {
    comment(id:1) {
      inserted_at
    }
  }
  """
  test "15 first commment with id 1 and geting its inserted at  " do
    response =
      build_conn()
      |> put_req_header(
        "authorization",
        @token
      )
      |> get("/api", query: @query)

    assert json_response(response, 200) == %{
             "data" => %{
               "comment" => %{"inserted_at" => "2018-07-11T23:08:17.345950"}
             }
           }
  end

  @query """
  {
    author(id: 1) {
      name
      comments(limit: 1, orderBy: {desc: INSERTED_AT})
      { body }
    }
  }
  """
  test "16 can limit and orderBy on a has_many relationship" do
    response =
      build_conn()
      |> put_req_header(
        "authorization",
        @token
      )
      |> get("/api", query: @query)

    assert json_response(response, 200) == %{
             "data" => %{
               "author" => %{"comments" => [%{"body" => "how are you"}], "name" => "George"}
             }
           }
  end

  @query """
  {
    authors(filter:{ids: [1,2]}){
      id
    }
  }
  """
  test "17 use ids filter in authors" do
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
                 %{"id" => "1"},
                 %{"id" => "2"}
               ]
             }
           }
  end
end
