# This is largely stolen from Moebius.
# Original author is Rob Conery
defmodule Seek.DB do
  defmacro __using__(_opts) do
    quote location: :keep do
      @name __MODULE__
      alias __MODULE__
      def start_link(opts) do
        opts
        |> prepare_extensions
        |> Postgrex.start_link
      end

      def prepare_extensions(opts) do
        #make sure we convert a tuple list, which will happen if our db is a worker
        opts = cond do
          Keyword.keyword?(opts) -> opts
          true -> Keyword.new([opts])
        end

        opts
        |> Keyword.put_new(:name, @name)
        |> Keyword.put_new(:extensions, [
          {Postgrex.Extensions.JSON, library: Poison},
        ])
      end

      def query!(query, parameters \\ %{}, struct_module \\ nil) do
        {prepared_query, prepared_parameters} = Seek.Statement.prepare(query, to_map(parameters))

        @name
        |> Postgrex.query!(prepared_query, prepared_parameters)
        |> Seek.Result.format(struct_module)
      end

      def first!(query, parameters \\ %{}, struct_module \\ nil) do
        query!(query, parameters, struct_module) |> List.first
      end

      defp to_map(struct) do
        case Map.has_key?(struct, :__struct__) do
          true -> Map.from_struct(struct)
          false -> struct
        end |> Enum.reduce(%{}, fn ({k, v}, acc) -> Map.put(acc, "#{k}", v) end)
      end
    end
  end
end

