defmodule Gatekeeper.TeamAuthorizer do
  import Plug.Conn
  import Phoenix.Controller

  alias Gatekeeper.Repo
  alias Gatekeeper.Users.User

  require Logger

  def init(opts), do: opts

  def call(%Plug.Conn{params: %{"team_id" => team}} = conn, _opts) do
    user =
      conn.assigns[:current_user]
      |> Repo.preload(:memberships)

    if User.has_membership?(user, team |> String.to_integer()) do
      conn
    else
      conn
      |> send_resp(401, "You are not a member of this team")
      |> halt()
    end
  end
end
