defmodule GatekeeperWeb.UserController do
  use GatekeeperWeb, :controller

  alias Gatekeeper.Users

  def show(conn, %{"id" => id}) do
    user = Users.get_user!(id)
    render(conn, "show.html", user: user)
  end
end
