defmodule GatekeeperWeb.PageController do
  use GatekeeperWeb, :controller

  alias Gatekeeper.Repo
  alias Gatekeeper.Guardian
  alias Gatekeeper.Teams

  def landing(conn, _params) do
    render(conn, "landing.html")
  end

  def index(conn, _params) do
    user =
      Guardian.Plug.current_resource(conn)
      |> Repo.preload(:approvals)

    approvals =
      user.approvals
      |> Repo.preload(:release)
      |> Enum.filter(fn a -> a.status == "initial" end)

    render(conn, "index.html", approvals: approvals, teams: Teams.list_teams())
  end
end
