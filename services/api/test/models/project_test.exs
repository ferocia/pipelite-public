defmodule Pipelite.ProjectTest do
  use Pipelite.ModelCase

  alias Pipelite.Project

  @valid_attrs %{
    name: "Some Project",
    payload: %{hello: "world"},
    remote_id: "1234-abcd",
    slug: "some-project"
  }
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Project.changeset(%Project{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Project.changeset(%Project{}, @invalid_attrs)
    refute changeset.valid?
  end
end
