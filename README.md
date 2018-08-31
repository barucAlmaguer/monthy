# ValiotApp

[ ![Codeship Status for DisruptiveAngels/valiot-app](https://app.codeship.com/projects/2edd70f0-4fb1-0136-e065-4202c386f1e6/status?branch=master)](https://app.codeship.com/projects/293608)

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create GraphQL schema with following specifications
    * Do not put ID's in the schemas
    * Use Integer instead of Int for schema
    * In case of DateTime put it as Datetime, so NaiveDatetime, Datetime, etc
    * Add default values with `@default(value: my_value)`
    * Example of GraphQL schema
```
type Author {
  name: String!
  lastName: String!
  dateOfBirth: Date
  active: Boolean @default(value: false)
  posts: [Post]
  comments: [Comment]
}

type Post {
  author: Author
  name: String! @unique
  body: Text!
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

## Adding Permissions
  * First, manually create CRUD permissions to a `user_id` and specific table (`relation`). Example using seeds:
  ```
  %ValiotApp.Api.Permission{user_id: 1, relation: :permission, create: true, update: true, read: true, delete: true} 
  |> ValiotApp.Repo.insert!()
  ```
  * The default values to `create`, `update`, `read`, and `delete` fields are *false*.
  ### Create permissions
  #### Example
  Here we create permission to user `1`, table `author`, with only read permission `true`.
```
mutation{
  createPermission(userId: 1 relation: AUTHOR read: true){
    id
  }
}
```

## Functionality
  * The are some interesting features for a better use of the api. The following features are before filter and after filter from the date that is created. The use of limit and offset in the certain list of objects. The last one is the application of filter in object associated many to one
  * after and before it includes the date selected too, an example of usage is ```authors(filter:{before:"2015-01-23T23:50:07Z"})```
  * the way to use limit and offset is very simple,  limit is for the amount of object that the query will bring from the database, offset is for the object it will start  an example of usage is ```authors(limit: 1, offset:1)``` this will bring the second one only from the module authors
  * Applying filters to module children is really simple and easy, here is an easy example
```
  authors{
    comment(limit:1, offset:2){
      id
      }
    }
```

## Making Queries
  * The following examples use the schema provided above.

 ### To run the tests:
 * Change the `@token` or eliminate it if not needed, in `error_filters_test.exs` 
 * Run the tests provided in the repository with `mix test` 

### To run a Query with GraphiQL :
  * Populate the Database with seeds inside of the files ending with `_test.exs` by putting them in `seeds.ex` file and running `mix run priv/repo/seeds.exs`

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
  * Components of a `mutation` / `subscription`
    * Result: The object created/updated/deleted by the mutation. May be null if mutation failed.
    * Successful: Indicates if the mutation completed successfully or not.
    * Messages
      * Code: A unique error code for the type of validation used.
      * Field: The input field that the error applies to.
      * Message: A friendly error message, appropriate for display to the end user.

### Example 1
  * Subscribe to *Create*
```
subscription {
  authorCreated {
    result {
      name
      lastName
      dateOfBirth
    }
    successful
    messages {
      code
      field
      message
    }
  }
}
```
  * Trigger the subscription with a mutation `createAuthor`
```
mutation {
  createAuthor(name: "Jennifer", lastName: "Jones", dateOfBirth: "1992-01-01") {
    result {
      name
      lastName
      dateOfBirth
    }
    successful
    messages {
      code
      field
      message
    }
  }
}
```
  * Output of the subscription:
```
{
  "data": {
    "createAuthor": [
      {
        "result": {
          "dateOfBirth": "1992-01-01",
          "lastName": "Jones",
          "name": "Jennifer"
        },
        "successful": true,
        "messages": []
      }
    ]
  }
}
```
### Example 2
  * Subscribe to *Update*
```
subscription {
  authorUpdated {
    result {
      name
      lastName
      dateOfBirth
      id
    }
  }
}
```
  * Trigger the subscription with a mutation `updateAuthor`
```
mutation ($input: UpdateAuthorParams) {
  updateAuthor(author: $input, id: 6) {
    result {
      name
      lastName
      id
      dateOfBirth
    }
  }
}
```
  * Define the variable in section *Query variables* :
```
{"input": {"name": "Liam"}}
```
### Example 3
  * Subscribe to *Delete*
```
subscription {
  authorDeleted {
    result {
      name
      lastName
      id
      dateOfBirth
    }
  }
}
```
  * Trigger the subscription with a mutation `deleteAuthor`
```
mutation {
  deleteAuthor(id: 7) {
    result {
      name
      lastName
      id
      dateOfBirth
    }
  }
}
```
