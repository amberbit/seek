defmodule Seek.Result do
  def format(result) do
    (result.rows || [])
    |> Enum.map &(to_map(&1, result.columns))
  end

  defp to_map(row, columns) do
    Enum.zip(columns, row) |> Enum.into(%{})
  end
end
