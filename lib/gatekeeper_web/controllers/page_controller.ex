defmodule GatekeeperWeb.PageController do
  use GatekeeperWeb, :controller

  alias Gatekeeper.Repo
  alias Gatekeeper.Guardian

  def index(conn, _params) do
    user =
      Guardian.Plug.current_resource(conn)
      |> Repo.preload(:approvals)

    approvals =
      user.approvals
      |> Repo.preload(:release)
      |> Enum.filter(fn a -> a.status == "initial" end)

    render(conn, "index.html", approvals: approvals)
  end
end
