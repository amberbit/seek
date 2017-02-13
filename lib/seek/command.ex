defmodule Seek.Command do
  defstruct query: nil, params: nil

  def new(query, params \\ %{}) do
    %Seek.Command{query: query, params: to_map(params)}
  end

  defp to_map(struct_or_map) do
    case Map.has_key?(struct_or_map, :__struct__) do
      true -> Map.from_struct(struct_or_map)
      false -> struct_or_map
    end |> Enum.reduce(%{}, fn ({k, v}, acc) -> Map.put(acc, "#{k}", v) end)
  end
end
