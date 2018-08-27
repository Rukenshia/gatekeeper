defmodule GatekeeperWeb.PageController do
  use GatekeeperWeb, :controller

  alias Gatekeeper.Repo

  def index(conn, _params) do
    user =
      get_session(conn, :current_user)
      |> Repo.preload(:approvals)

    approvals =
      user.approvals
      |> Repo.preload(:release)
      |> Enum.filter(fn a -> a.status == "initial" end)

    render(conn, "index.html", approvals: approvals)
  end
end
