defmodule Pipelite.Api.V1.WebhookControllerTest do
  use Pipelite.ConnCase

  # alias Pipelite.Build
  # alias Pipelite.Project

  @valid_attrs %{}
  @invalid_attrs %{}

  setup do
    conn = conn() |> put_req_header("accept", "application/json")
    {:ok, conn: conn}
  end

  # test "creates and renders resource when data is valid", %{conn: conn} do
  #   conn = post conn, webhook_path(conn, :create), webhook: @valid_attrs
  #   assert json_response(conn, 200)["data"]["id"]
  #   assert Repo.get_by(Webhook, @valid_attrs)
  # end

  # test "does not create resource and renders errors when data is invalid", %{conn: conn} do
  #   conn = post conn, webhook_path(conn, :create), webhook: @invalid_attrs
  #   assert json_response(conn, 422)["errors"] != %{}
  # end
end
