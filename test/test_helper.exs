ExUnit.start()

defmodule Test.DB do
  use Seek.DB
end

System.cmd("dropdb", ["seek_test"])
System.cmd("createdb", ["seek_test"])

worker = Supervisor.Spec.worker(Test.DB, [Seek.connection_config])
Supervisor.start_link [worker], strategy: :one_for_one

