defmodule GatekeeperWeb.PageController do
  use GatekeeperWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
