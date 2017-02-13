# Seek

Seek is a think wrapper around Postgrex. It allows you to write SQL
queries using SQL, pass parameters and process returned values slightly
easier than using raw driver.

## Installation

Seek is [available in Hex](https://hex.pm/), the package can be installed
by adding `seek` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:seek, "~> 0.0.1"}]
end
```

Put a database configuration in your `config.exs` too:

```elixir
config :seek, connection: [
  database: "myappdb",
  pool_mod: DBConnection.Poolboy
]
```

and ensure Seek is started with your application:

```elixir
def application do
  [applications: [:seek]]
end
```

To perform a simple query, you can use:

```elixir
Seek.DB.query!("SELECT * FROM users where email = :email", %{"email" =>
"john@example.com"})
=> [%{"id" => 1, "email" => "john@example.com"}]
```

## Features

### Simple querying

Let's create some tables:

```elixir
Seek.DB.query!("CREATE TABLE users (id SERIAL NOT NULL PRIMARY KEY, email TEXT")
=> []

Seek.DB.query!("CREATE TABLE posts (id SERIAL NOT NULL PRIMARY KEY, subject TEXT, user_id INT references users(id))")
=> []
```

We can insert the user passed as hash:

```elixir
Seek.DB.query!("INSERT INTO users (email) VALUES (:email) returning *", %{"email" => "jack@example.com"})
=> [%{"email" => "jack@example.com", "id" => 2}]
```

or, if we have User model such as, we can use it to perform insert:

```elixir
defmodule User do
  defstruct id: nil, email: nil
end

Seek.DB.query!("INSERT INTO users (email) VALUES (:email) returning *", %User{email: "jack@example.com"})
=> [%{"email" => "jack@example.com", "id" => 3}]
```

We can also ask for the returned values to be inserted into given
struct:

```elixir
Seek.DB.query!("SELECT * FROM users", %{}, User)
=> [
  %User{email: "jack.black@example.com", id: 1},
  %User{email: nil, id: 2},
  %User{email: "jack@example.com", id: 3}
]
```

We can ask for single entry too:
```elixir
Seek.DB.first!("SELECT * FROM users where id = :id LIMIT 1", %{"id" => 1}, User)
=> %User{email: "jack.black@example.com", id: 1},
```

## Join statements

You can perform join statements and get results returned into desired
structs this way:

```elixir
Seek.DB.query!("SELECT users.id AS user__id, email AS user__email, posts.id AS post__id, posts.subject AS post__subject FROM users INNER JOIN posts on posts.user_id = users.id", %{}, %{"user" => User, "post" => Post})
=> [
  %{"post" => %Post{id: 1, subject: "Hello"},
    "user" => %User{email: "jack.black@example.com", id: 1}}
]
```

API Documentation is available on [HexDocs](https://hexdocs.pm/seek).

