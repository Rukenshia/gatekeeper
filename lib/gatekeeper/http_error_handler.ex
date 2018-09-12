defmodule Gatekeeper.ErrorHandler do
  import Plug.Conn

  require Logger

  def auth_error(conn, {type, reason}, _opts) do
    body = to_string(type)

    Logger.error(inspect(reason))

    conn
    |> put_resp_content_type("text/plain")
    |> send_resp(401, body)
  end
end
