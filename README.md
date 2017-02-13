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
  database: "seek_test",
  pool_mod: DBConnection.Poolboy
]
```

and ensure Seek is started with your application:

def application do
  [applications: [:seek]]
end


To perform a simple query, you can use:

```elixir
Seek.DB.query!("SELECT * FROM users where email = :email", %{"email" =>
"john@example.com"})
```

API Documentation is available on [HexDocs](https://hexdocs.pm/seek).

