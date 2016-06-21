defmodule Pipelite.JobTest do
  use Pipelite.ModelCase

  alias Pipelite.Job

  @valid_attrs %{
    name: "running some tests",
    payload: %{hello: "world"},
    remote_id: "1234-abcd",
    state: "passing",
    type: "script"
  }
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Job.changeset(%Job{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Job.changeset(%Job{}, @invalid_attrs)
    refute changeset.valid?
  end
end
