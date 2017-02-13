defmodule Seek.Result do
  def format(result, nil) do
    (result.rows || []) |> Enum.map(&(to_map(&1, result.columns)))
  end

  def format(result, struct_module) do
    format(result, nil) |> Enum.map(&(to_struct(&1, struct_module)))
  end

  defp to_map(row, columns) do
    Enum.zip(columns, row) |> Enum.into(%{})
  end

  # Author: Jose Valim
  # https://groups.google.com/forum/#!msg/elixir-lang-talk/6geXOLUeIpI/L9einu4EEAAJ
  defp to_struct(map, struct_module) do
    struct = struct(struct_module)

    Enum.reduce Map.to_list(struct), struct, fn {k, _}, acc ->
      case Map.fetch(map, "#{k}") do
        {:ok, v} -> %{acc | k => v}
        :error -> acc
      end
    end
  end
end
