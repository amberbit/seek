# This is largely stolen from Moebius.
# Original author is Rob Conery
defmodule Seek.DatabaseHandle do
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

      def query!(query, params \\ %{}, struct_module \\ nil) do
        Seek.Command.new(query, params) |> execute(struct_module)
      end

      def first!(query, params \\ %{}, struct_module \\ nil) do
        query!(query, params, struct_module) |> List.first
      end

      def execute(cmd, struct_module \\ nil) do
        {prepared_query, prepared_params} = Seek.Statement.prepare(cmd)

        @name
        |> Postgrex.query!(prepared_query, prepared_params)
        |> Seek.Result.format(struct_module)
      end
    end
  end
end

