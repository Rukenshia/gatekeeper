defmodule GatekeeperWeb.PageViewTest do
  use GatekeeperWeb.ConnCase, async: true
  import Phoenix.View

  alias Gatekeeper.Users.User
  alias Gatekeeper.Releases.Release
  alias Gatekeeper.Releases.Approval
  alias Gatekeeper.Teams.Team

  defp landing_assigns(conn) do
    conn =
      conn
      |> put_private(:phoenix_endpoint, GatekeeperWeb.Endpoint)

    %{conn: conn}
  end

  defp index_assigns(conn) do
    conn =
      conn
      |> put_private(:phoenix_endpoint, GatekeeperWeb.Endpoint)

    team = %Team{id: 1}
    release = %Release{id: 1, team_id: team.id, version: "1.2.3"}
    approval = %Approval{user_id: 1, release_id: 1, status: "initial"}
    release = Map.put(release, :approvals, [approval])
    approval = Map.put(approval, :release, release)

    %{
      conn: conn,
      current_user: %User{name: "Test User", teams: [team]},
      approvals: [approval],
      teams: [team]
    }
  end

  test "landing.html has a login button", %{conn: conn} do
    assert render_to_string(GatekeeperWeb.PageView, "landing.html", landing_assigns(conn)) =~
             ~r/<a.*>Login<\/a>/i
  end

  describe "index.html" do
    test "shows the username", %{conn: conn} do
      assigns = index_assigns(conn)

      assert render_to_string(GatekeeperWeb.PageView, "index.html", assigns) =~
               ~r/#{assigns[:current_user].name}/
    end

    test "shows releases waiting for the logged in user to approve", %{conn: conn} do
      assigns = index_assigns(conn)
      release = Enum.at(assigns[:approvals], 0).release

      assert render_to_string(GatekeeperWeb.PageView, "index.html", assigns) =~ release.version
    end

    test "lists all users teams", %{conn: conn} do
      assigns = index_assigns(conn)

      assert render_to_string(GatekeeperWeb.PageView, "index.html", assigns) =~
               team_path(assigns[:conn], :show, Enum.at(assigns[:teams], 0).id)
    end
  end
end
