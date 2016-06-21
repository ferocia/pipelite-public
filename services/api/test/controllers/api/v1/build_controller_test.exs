defmodule Pipelite.Api.V1.BuildControllerTest do
  use Pipelite.ConnCase
  alias Pipelite.Build
  alias Pipelite.Project

  @valid_attrs %{
    branch: "master",
    payload: %{hello: "world"},
    remote_id: "1234-abcd",
    state: "passing",
  }
  @invalid_attrs %{}

  setup do
    conn = conn() |> put_req_header("accept", "application/json")
    {:ok, conn: conn}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, api_v1_build_path(conn, :index)
    assert json_response(conn, 200) == []
  end

  test "shows chosen resource", %{conn: conn} do
    {:ok, project} = Repo.insert Project.changeset(%Project{}, %{
      name: "Some Project",
      payload: %{hello: "world"},
      remote_id: "1234-abcd",
      slug: "some-project",
    })

    {:ok, build} = Repo.insert(Ecto.Model.build(project, :builds, @valid_attrs))
    conn = get conn, api_v1_build_path(conn, :show, build)
    assert json_response(conn, 200)["id"] == build.id
    assert Repo.get(Build, build.id)
  end
end
