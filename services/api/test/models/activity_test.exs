defmodule Pipelite.ActivityTest do
  use Pipelite.ModelCase

  alias Pipelite.Activity

  @valid_attrs %{
    action: "insert",
    data: %{
      foo: "bar"
    }
  }
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Activity.changeset(%Activity{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Activity.changeset(%Activity{}, @invalid_attrs)
    refute changeset.valid?
  end
end
