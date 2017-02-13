ExUnit.start()

defmodule Test.DB do
  use Seek.DatabaseHandle
end

worker = Supervisor.Spec.worker(Test.DB, [Seek.connection_config])
Supervisor.start_link [worker], strategy: :one_for_one

