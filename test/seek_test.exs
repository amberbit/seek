defmodule Test.User do
  defstruct id: nil, email: nil
end

defmodule SeekTest do
  use ExUnit.Case
  doctest Seek

  setup do
    Test.DB.query!("DROP TABLE IF EXISTS posts")
    Test.DB.query!("DROP TABLE IF EXISTS users")
    Test.DB.query!("CREATE TABLE users (id SERIAL NOT NULL PRIMARY KEY, email TEXT)")
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

  test "supports joins" do
    Test.DB.query!("CREATE TABLE posts (id SERIAL NOT NULL, subject text, user_id INT references users(id))")
    user = Test.DB.first!("INSERT INTO users (email) VALUES (:email) returning *", %Test.User{email: "jack.black@example.com"}, Test.User)
    Test.DB.query!("INSERT INTO posts (subject, user_id) VALUES (:subject, :user_id)", %{"subject" => "Subject", "user_id" => user.id})


    assert(
      Test.DB.first!("SELECT users.email AS user__email, posts.subject AS post__subject FROM users INNER JOIN posts ON posts.user_id = users.id") ==
        %{"user" => %{"email" => "jack.black@example.com"}, "post" => %{"subject" => "Subject"}}
    )
  end

  test "supports multi line SQL" do
    Test.DB.query!("CREATE TABLE posts\n(id SERIAL NOT NULL, subject text, user_id INT references users(id))")
    user = Test.DB.first!("INSERT INTO
    users (email) VALUES (:email)
    returning *", %Test.User{email: "jack.black@example.com"}, Test.User)
    Test.DB.query!("INSERT INTO posts\n(subject, user_id) VALUES (:subject, :user_id)", %{"subject" => "Subject", "user_id" => user.id})


    assert(
      Test.DB.first!("SELECT users.email\nAS user__email, posts.subject AS post__subject FROM users INNER JOIN posts ON posts.user_id = users.id") ==
        %{"user" => %{"email" => "jack.black@example.com"}, "post" => %{"subject" => "Subject"}}
    )
  end
end

