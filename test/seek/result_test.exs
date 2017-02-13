defmodule Test.ResultUser do
  defstruct id: nil, email: nil
end

defmodule Test.ResultPost do
  defstruct id: nil, subject: nil
end


defmodule Seek.ResultTest do
  use ExUnit.Case

  doctest Seek.Result

  test "processes the result to usable format" do
    result = Seek.Result.format(%Postgrex.Result{columns: ["id", "email"], rows: [[1, "john@example.com"]]}, nil)
    assert result == [%{"id" => 1, "email" => "john@example.com"}]
  end

  test "puts result into desired struct" do
    result = Seek.Result.format(%Postgrex.Result{columns: ["id", "email"], rows: [[1, "john@example.com"]]}, Test.ResultUser)
    assert result == [%Test.ResultUser{id: 1, email: "john@example.com"}]
  end

  test "processes nested keys" do
    result = Seek.Result.format(
      %Postgrex.Result{
        columns: ["user__id", "user__email", "post__id", "post__subject"],
        rows: [[1, "john@example.com", 2, "Hello"]]}, nil
    )

    assert result == [%{"user" => %{"id" => 1, "email" => "john@example.com"}, "post" => %{"id" => 2, "subject" => "Hello"}}]
  end

  test "puts results into nested structs" do
    result = Seek.Result.format(
      %Postgrex.Result{
        columns: ["user__id", "user__email", "post__id", "post__subject"],
        rows: [[1, "john@example.com", 2, "Hello"]]},
      %{"user" => Test.ResultUser, "post" => Test.ResultPost}
    )

    assert result == [%{"user" => %Test.ResultUser{id: 1, email: "john@example.com"}, "post" => %Test.ResultPost{id: 2, subject: "Hello"}}]
  end
end
