# ValiotApp

[ ![Codeship Status for DisruptiveAngels/valiot-app](https://app.codeship.com/projects/2edd70f0-4fb1-0136-e065-4202c386f1e6/status?branch=master)](https://app.codeship.com/projects/293608)

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create GraphQL schema with following specifications
    * Do not put ID's in the schemas
    * Use Integer instead of Int for schema
    * In case of DateTime put it as Datetime, so NaiveDatetime, Datetime, etc
    * Example of GraphQL schema
```
type Author {
  name: String!
  lastName: String!
  dateOfBirth: Date
  posts: [Post]
  comments: [Comment]
}

type Post {
  author: Author
  name: String!
  body: String!
  status: Status
  comments: [Comment]
}

type Comment {
  author: Author
  post: Post
  body: String!
}

enum Status {
  APPROVED
  PENDING
  REJECTED
}
```
  * Run `mix valiot.gen.api /path/to/schema.graphql`
  * Create and migrate your database with `mix ecto.create && mix ecto.migrate`
  * Run the formatter with `mix format`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](http://www.phoenixframework.org/docs/deployment).



## Making Queries
  * The following examples use the schema provided above.

### To run the tests:
  * Change the `@token` or eliminate it if not needed, in `error_filters_test.exs` 
  * Run the tests provided in the repository with `mix test` 
  

### To run a Query with GraphiQL :
  * Populate the Database with `mix run priv/repo/seeds.exs`

#### Example 1
  * Get children values of a field:  
```
{
  authors{
    name
    dateOfBirth
  }
}
```
  * Output:
```
{
  "data": {
    "authors": [
      {
        "name": "George",
        "dateOfBirth": "1990-01-01"
      },
      {
        "name": "Henry",
        "dateOfBirth": "1995-02-01"
      },
      {
        "name": "Rebeca",
        "dateOfBirth": "1999-05-07"
      },
      {
        "name": "Anna",
        "dateOfBirth": "1980-10-07"
      },
      {
        "name": "Samantha",
        "dateOfBirth": "2000-01-01"
      }   
    ]
  }
}
```
#### Example 2
  * Get children values of a field using the keyword `filter`
```
{
  authors(filter: {name: "Rebeca"}) {
    lastName
  }
}
```
  * Output:
```
{
  "data": {
    "authors": [
      {
        "lastName": "Jones"
      }
    ]
  }
}
```
#### Example 3.1
  * Get children values of a field using the keyword `filter` and a variable `$term`
```
query ($term: String) {
    authors(filter: {last_name: $term}) {
      name
      dateOfBirth
      lastName
    }
}
```
  * Define the variable in section *Query variables* :
```
{"term": "Williams"}
```
  * Output:
```
{
  "data": {
    "authors": [
      {
        "name": "George",
        "lastName": "Williams",
        "dateOfBirth": "1990-01-01"
      }
    ]
  }
}
```
#### Example 3.2
  * Get children values of a field using the keyword `filter` and a variable `$term`
```
query ($term: Int) {
    authors(filter: {id: $term}) {
      lastName
      dateOfBirth
    }
  }
```
  * Define the variable in section *Query variables* :
```
{"term": 1}
```
  * Output:
```
{
  "data": {
    "authors": [
      {
        "lastName": "Williams",
        "dateOfBirth": "1990-01-01"
      }
    ]
  }
}
```

## Subscriptions and Mutations
  * Run the test provided for subscriptions with `mix test`

### Example 1
  * Subscribe to *Create*
```
subscription {
  createAuthor {
    name
    lastName
    dateOfBirth
  }
}
```
  * Trigger the subscription with a mutation `createAuthor`
```
mutation {
  createAuthor(name: "Jennifer", lastName: "Jones", dateOfBirth: "1992-01-01") {
    name
    lastName
    dateOfBirth
  }
}
```
  * Output of the subscription:
```
{
  "data": {
    "createAuthor": [
      {
        "dateOfBirth": "1992-01-01",
        "lastName": "Jones",
        "name": "Jennifer"
      }
    ]
  }
}
```
### Example 2
  * Subscribe to *Update*
```
subscription {
  updateAuthor {
    name
    lastName
    dateOfBirth
    id
  }
}
```
  * Trigger the subscription with a mutation `updateAuthor`
```
mutation ($input: UpdateAuthorParams) {
  updateAuthor(author: $input, id: 6) {
    name
    lastName
    id
    dateOfBirth
  }
}
```
  * Define the variable in section *Query variables* :
```
{"input": {"name": "Liam"}}
```
## Example 3
  * Subscribe to *Delete*
```
subscription {
  deleteAuthor {
    name
    lastName
    id
    dateOfBirth
  }
}
```
  * Trigger the subscription with a mutation `deleteAuthor`
```
mutation {
  deleteAuthor(id: 7) {
    name
    lastName
    id
    dateOfBirth
  }
}
```

