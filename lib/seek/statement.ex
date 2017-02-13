defmodule Seek.Statement do
  def prepare(%{query: query, params: params} = cmd) do
    { prepared_query, params_template } = process_query(query)

    { prepared_query, params |> prepare_params(params_template) }
  end

  defp process_query(query) do
    query
    |> extract_params_map
    |> substitute_parameter_names(query)
  end

  defp extract_params_map(query) do
    Regex.scan(~r/(\:[a-zA-Z0-9]+)/i, query)
    |> Enum.map(&hd/1)
    |> Enum.map(&( String.slice(&1, 1..-1) ))
    |> Enum.uniq
  end

  defp substitute_parameter_names(named_params, query) do
    {do_substitute(query, named_params, 1), named_params}
  end

  defp do_substitute(query, [h | t], index) do
    query
    |> String.replace(":#{h}", "$#{index}")
    |> do_substitute(t, index + 1)
  end

  defp do_substitute(query, _ = [], _) do
    query
  end

  defp prepare_params(params, params_template) do
    params_template
    |> Enum.map(&(params[&1]))
  end
end
