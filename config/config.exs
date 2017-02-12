use Mix.Config

config :seek, connection: [
  database: "seek_test",
  pool_mod: DBConnection.Poolboy
]
