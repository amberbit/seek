defmodule Seek.StatementTest do
  use ExUnit.Case

  doctest Seek.Statement

  test "expanding single query parameters" do
    {statement, params} = Seek.Statement.prepare "SELECT * FROM users WHERE id=:id", %{"id" => 1}
    assert statement == "SELECT * FROM users WHERE id=$1"
    assert params == [ 1 ]
  end

  test "expanding multiple query parameters" do
    {statement, params} = Seek.Statement.prepare "SELECT * FROM users WHERE id=:id AND email=:email", %{"id" => 1, "email" => "jack.black@example.com"}
    assert statement == "SELECT * FROM users WHERE id=$1 AND email=$2"
    assert params == [ 1, "jack.black@example.com" ]
  end

  test "expanding repeated query parameters" do
    {statement, params} = Seek.Statement.prepare "SELECT * FROM users WHERE id=:id AND (email=:email AND id<>:id)", %{"id" => 1, "email" => "jack.black@example.com"}
    assert statement == "SELECT * FROM users WHERE id=$1 AND (email=$2 AND id<>$1)"
    assert params == [ 1, "jack.black@example.com" ]
  end
end
