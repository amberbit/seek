defmodule Test.User do
  defstruct id: nil, email: nil
end

defmodule SeekTest do
  use ExUnit.Case
  doctest Seek

  setup do
    Test.DB.query!("DROP TABLE IF EXISTS users")
    Test.DB.query!("CREATE TABLE users (id BIGSERIAL NOT NULL, email TEXT)")
  end


  test "supports simple queries" do
    Test.DB.query!("INSERT INTO users (email) VALUES ('jack.black@example.com')")

    assert Test.DB.query!("SELECT * FROM users") == [%{"id" => 1, "email" => "jack.black@example.com"}]
    assert Test.DB.query!("SELECT count(*) FROM users") == [%{"count" => 1}]
    assert Test.DB.query!("DELETE FROM users RETURNING *") == [%{"id" => 1, "email" => "jack.black@example.com"}]
    assert Test.DB.query!("SELECT count(*) FROM users") == [%{"count" => 0}]
  end

  test "supports query params" do
    Test.DB.query!("INSERT INTO users (email) VALUES (:email)", %{"email" => "jack.black@example.com"})
    assert Test.DB.query!("SELECT * FROM users") == [%{"id" => 1, "email" => "jack.black@example.com"}]
  end

  test "supports querying for first row" do
    Test.DB.query!("INSERT INTO users (email) VALUES (:email)", %{"email" => "jack.black@example.com"})

    assert Test.DB.first!("SELECT * FROM users") == %{"id" => 1, "email" => "jack.black@example.com"}
  end

  test "supports using structs" do
    Test.DB.query!("INSERT INTO users (email) VALUES (:email)", %Test.User{email: "jack.black@example.com"})

    assert Test.DB.first!("SELECT * FROM users") == %{"id" => 1, "email" => "jack.black@example.com"}
    assert Test.DB.first!("SELECT * FROM users", %{}, Test.User) == %Test.User{id: 1, email: "jack.black@example.com"}
  end
end

