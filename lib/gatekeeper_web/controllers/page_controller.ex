defmodule GatekeeperWeb.PageController do
  use GatekeeperWeb, :controller

  alias Gatekeeper.Users

  def index(conn, _params) do
    # FIXME(jan): proper session handling... sometime...
    user = Users.get_user!(1)
    conn = put_session(conn, :current_user, user)

    render(conn, "index.html")
  end
end
