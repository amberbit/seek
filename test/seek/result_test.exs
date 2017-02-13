defmodule Test.ResultUser do
  defstruct id: nil, email: nil
end

defmodule Seek.ResultTest do
  use ExUnit.Case

  doctest Seek.Result

  test "processes the result to usable format" do
    assert Seek.Result.format(%Postgrex.Result{columns: ["id", "email"], rows: [[1, "john@example.com"]]}, nil)
      == [%{"id" => 1, "email" => "john@example.com"}]
  end

  test "puts result into desired struct" do
    assert Seek.Result.format(%Postgrex.Result{columns: ["id", "email"], rows: [[1, "john@example.com"]]}, Test.ResultUser)
      == [%Test.ResultUser{id: 1, email: "john@example.com"}]

  end

  test "processes nested keys" do
    assert Seek.Result.format(%Postgrex.Result{columns: ["user__id", "user__email", "post__id", "post__subject"], rows: [[1, "john@example.com", 2, "Hello"]]}, nil)
      == [%{"user" => %{"id" => 1, "email" => "john@example.com"}, "post" => %{"id" => 2, "subject" => "Hello"}}]
  end
end
