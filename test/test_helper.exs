ExUnit.start()

defmodule Test.DB do
  use Seek.DB
end

worker = Supervisor.Spec.worker(Test.DB, [Seek.connection_config])
Supervisor.start_link [worker], strategy: :one_for_one

