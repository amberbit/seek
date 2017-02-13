defmodule Seek.Result do
  import DeepMerge, only: [deep_merge: 2]

  def format(result, nil) do
    (result.rows || []) |> Enum.map(&(to_map(&1, result.columns)))
  end

  def format(result, struct_template) do
    format(result, nil) |> Enum.map(&(to_struct(&1, struct_template)))
  end

  defp to_map(row, columns) do
    Enum.zip(columns, row)
    |> Enum.into(%{})
    |> to_result
  end

  # Author: Jose Valim
  # https://groups.google.com/forum/#!msg/elixir-lang-talk/6geXOLUeIpI/L9einu4EEAAJ
  defp to_struct(map, struct_module) when is_atom(struct_module) do
    struct = struct(struct_module)

    Enum.reduce Map.to_list(struct), struct, fn {k, _}, acc ->
      case Map.fetch(map, "#{k}") do
        {:ok, v} -> %{acc | k => v}
        :error -> acc
      end
    end
  end

  defp to_struct(map, struct_template) do
    Enum.reduce map, %{}, fn ({k, v}, acc) ->
      case struct_template[k] do
        nil -> Map.put(acc, k, v)
        _ -> Map.put(acc, k, to_struct(v, struct_template[k]))
      end
    end
  end

  defp to_result(map) do
    Enum.reduce map, %{}, fn ({k, v}, acc) ->
      case String.split(k, "__") do
        # TODO: get rid of deep merge dep
        # TODO: maybe allow multiple levels?
        [prefix, new_k] -> deep_merge(acc, %{prefix => %{}}) |> deep_merge(%{prefix => %{new_k => v}})
        _ -> Map.put(acc, k, v)
      end
    end
  end
end
