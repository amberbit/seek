defmodule Seek.StatementTest do
  use ExUnit.Case

  doctest Seek.Statement

  test "expanding single query params" do
    {statement, params} = Seek.Statement.prepare %{query: "SELECT * FROM users WHERE id=:id", params: %{"id" => 1}}
    assert statement == "SELECT * FROM users WHERE id=$1"
    assert params == [ 1 ]
  end

  test "expanding multiple query params" do
    {statement, params} = Seek.Statement.prepare %{query: "SELECT * FROM users WHERE id=:id AND email=:email", params: %{"id" => 1, "email" => "jack.black@example.com"}}
    assert statement == "SELECT * FROM users WHERE id=$1 AND email=$2"
    assert params == [ 1, "jack.black@example.com" ]
  end

  test "expanding repeated query params" do
    {statement, params} = Seek.Statement.prepare %{query: "SELECT * FROM users WHERE id=:id AND (email=:email AND id<>:id)", params: %{"id" => 1, "email" => "jack.black@example.com"}}
    assert statement == "SELECT * FROM users WHERE id=$1 AND (email=$2 AND id<>$1)"
    assert params == [ 1, "jack.black@example.com" ]
  end
end
