defmodule GatekeeperWeb.TeamMemberController do
  require Logger

  use GatekeeperWeb, :controller

  import Ecto.Query, only: [from: 2]
  alias Gatekeeper.Repo
  alias Gatekeeper.Teams.TeamMember

  def api_get_members(conn, %{"team_id" => id}) do
    query =
      from(t in TeamMember,
        where: t.team_id == ^id
      )

    members = Repo.all(query)
    Logger.debug(inspect(members))
    render(conn, "members.json", members: members)
  end
end
