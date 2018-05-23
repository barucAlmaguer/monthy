# ValiotApp

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
  coments: [Comment]
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
