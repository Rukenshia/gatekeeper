defmodule Gatekeeper.ErrorHandler do
  use GatekeeperWeb, :controller

  import Plug.Conn

  require Logger

  def auth_error(conn, {type, reason}, _opts) do
    body = to_string(type)

    Logger.error(inspect(reason))

    case reason do
      :token_expired ->
        conn
        |> put_flash(:info, "You have been logged out automatically, please log in again.")
        |> redirect(to: "/")

      _ ->
        conn
        |> put_resp_content_type("text/plain")
        |> send_resp(401, body)
    end
  end
end
