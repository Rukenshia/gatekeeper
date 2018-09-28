defmodule GatekeeperWeb.TeamControllerTest do
  use GatekeeperWeb.ConnCase

  alias Gatekeeper.Teams

  @create_attrs %{name: "some name"}
  @update_attrs %{name: "some updated name"}
  @invalid_attrs %{name: nil}

  def fixture(:team) do
    {:ok, team} = Teams.create_team(@create_attrs)
    team
  end

  describe "edit team" do
    setup [:create_team]

    test "renders form for editing chosen team", %{conn: conn, team: team} do
      conn = get(conn, team_path(conn, :edit, team))
      assert html_response(conn, 200) =~ "Edit Team"
    end
  end

  describe "update team" do
    setup [:create_team]

    test "redirects when data is valid", %{conn: conn, team: team} do
      conn = put(conn, team_path(conn, :update, team), team: @update_attrs)
      assert redirected_to(conn) == team_path(conn, :show, team)

      conn = get(conn, team_path(conn, :show, team))
      assert html_response(conn, 200) =~ "some updated name"
    end

    test "renders errors when data is invalid", %{conn: conn, team: team} do
      conn = put(conn, team_path(conn, :update, team), team: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Team"
    end
  end

  defp create_team(_) do
    team = fixture(:team)
    {:ok, team: team}
  end
end
