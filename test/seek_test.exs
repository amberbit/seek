defmodule SeekTest do
  use ExUnit.Case
  doctest Seek


  test "supports simple queries" do
    Test.DB.query!("CREATE TABLE users (id BIGSERIAL NOT NULL, email TEXT)")

    Test.DB.query!("INSERT INTO users (email) VALUES ('jack.black@example.com')")

    assert Test.DB.query!("SELECT * FROM users") == [%{"id" => 1, "email" => "jack.black@example.com"}]
    assert Test.DB.query!("SELECT count(*) FROM users") == [%{"count" => 1}]
    assert Test.DB.query!("DELETE FROM users RETURNING *") == [%{"id" => 1, "email" => "jack.black@example.com"}]
    assert Test.DB.query!("SELECT count(*) FROM users") == [%{"count" => 0}]
  end
end

