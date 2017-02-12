# Parts may be stolen by him from Ecto and authored by Jose Valim,
# then stolen by me from Moebius ;)
# TODO: Which probably means this part should be moved to Postgrex BTW.
defmodule Seek do
  def connection_config(), do: connection_config(:connection)
  def connection_config(key) when is_atom(key) do
    opts = Application.get_env(:seek, key)
    cond do
      Keyword.has_key?(opts, :url) -> Keyword.merge(opts, parse_connection(opts[:url]))
      true -> opts
    end
  end

  #thanks to the Ecto team for this code!
  defp parse_connection(url) when is_binary(url) do
    info = url |> URI.decode() |> URI.parse()

    if is_nil(info.host) do
      raise "Invalid URL: host is not present"
    end

    if is_nil(info.path) or not (info.path =~ ~r"^/([^/])+$") do
      raise "Invalid URL: path should be a database name"
    end

    destructure [username, password], info.userinfo && String.split(info.userinfo, ":")
    "/" <> database = info.path

    opts = [username: username,
      password: password,
      database: database,
      hostname: info.host,
      port:     info.port]

    Enum.reject(opts, fn {_k, v} -> is_nil(v) end)
  end
end
