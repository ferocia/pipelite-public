defmodule Pipelite.LogTest do
  use Pipelite.ModelCase

  alias Pipelite.Log

  @valid_attrs %{
    body: "hello world",
    length: 11
  }
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Log.changeset(%Log{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Log.changeset(%Log{}, @invalid_attrs)
    refute changeset.valid?
  end
end
