defmodule GatekeeperWeb.TeamControllerTest do
  use GatekeeperWeb.ConnCase
  require Logger

  alias Gatekeeper.Teams
  alias Gatekeeper.Users
  alias Gatekeeper.Repo

  @create_attrs %{name: "some name"}
  @create_user_attrs %{name: "some user", email: "some@user.com"}

  def fixture(:team) do
    {:ok, team} = Teams.create_team(@create_attrs)
    team
  end

  def fixture(:user) do
    {:ok, user} = Users.create_user(@create_user_attrs)
    user
  end

  def fixture(:team_member, team, user) do
    {:ok, membership} =
      %Teams.TeamMember{
        user_id: user.id,
        team_id: team.id,
        role: "administrator"
      }
      |> Repo.insert()

    membership
  end

  describe "authenticated edit team when not part of the team" do
    setup [:create_team, :create_user, :authenticate_user]

    test "renders form for editing chosen team", %{conn: conn, team: team} do
      conn = get(conn, team_path(conn, :edit, team))
      assert response(conn, 401) =~ "You are not a member of this team"
    end

    test "does not leak the teams api key", %{conn: conn, team: team} do
      conn = get(conn, team_path(conn, :edit, team))
      assert !(response(conn, 401) =~ team.api_key)
    end
  end

  describe "authenticated edit team" do
    setup [:create_team, :create_user, :associate_user_with_team, :authenticate_user]

    test "shows the teams members", %{conn: conn, team: team} do
      conn = get(conn, team_path(conn, :edit, team))
      assert response(conn, 200) =~ "Members"
    end

    test "shows the teams api key", %{conn: conn, team: team} do
      conn = get(conn, team_path(conn, :edit, team))
      assert response(conn, 200) =~ team.api_key
    end
  end

  defp create_team(_) do
    team = fixture(:team)
    {:ok, team: team}
  end

  defp create_user(_) do
    user = fixture(:user)
    {:ok, user: user}
  end

  defp authenticate_user(%{conn: conn, user: user}) do
    conn =
      conn
      |> Gatekeeper.Guardian.Plug.sign_in(user, %{})

    {:ok, conn: conn}
  end

  defp associate_user_with_team(%{user: user, team: team}) do
    membership = fixture(:team_member, team, user)

    {:ok, membership: membership}
  end
end
