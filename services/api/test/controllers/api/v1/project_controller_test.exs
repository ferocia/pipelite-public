defmodule Pipelite.Api.V1.ProjectControllerTest do
  use Pipelite.ConnCase
  alias Pipelite.Project

  @valid_attrs %{
    name: "Some Project",
    payload: %{hello: "world"},
    remote_id: "1234-abcd",
    slug: "some-project",
  }
  @invalid_attrs %{}

  setup do
    conn = conn() |> put_req_header("accept", "application/json")
    {:ok, conn: conn}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, api_v1_project_path(conn, :index)
    assert json_response(conn, 200) == []
  end

  test "shows chosen resource", %{conn: conn} do
    {:ok, project} = Repo.insert Project.changeset(%Project{}, @valid_attrs)
    conn = get conn, api_v1_project_path(conn, :show, project.slug)
    assert json_response(conn, 200)["id"] == project.id
    assert Repo.get(Project, project.id)
  end
end
