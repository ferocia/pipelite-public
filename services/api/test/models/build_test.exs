defmodule Pipelite.BuildTest do
  use Pipelite.ModelCase

  alias Pipelite.Build

  @valid_attrs %{
    branch: "master",
    payload: %{hello: "world"},
    remote_id: "1234-abcd",
    state: "passing"
  }
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Build.changeset(%Build{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Build.changeset(%Build{}, @invalid_attrs)
    refute changeset.valid?
  end
end
