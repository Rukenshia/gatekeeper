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

  def api_add_member(conn, %{"team_id" => id, "user_id" => user_id}) do
    changeset =
      TeamMember.changeset(%TeamMember{}, %{
        user_id: user_id,
        team_id: String.to_integer(id),
        role: "administrator",
        mandatory_approver: false
      })

    case Repo.insert_or_update(changeset) do
      {:ok, changeset} ->
        conn
        |> json(TeamMember.safe_json(changeset))

      {:error, _} ->
        conn
        |> json(%{ok: false})
    end
  end

  def api_remove_member(conn, %{"team_id" => team_id, "user_id" => user_id}) do
    membership =
      Repo.get_by!(
        TeamMember,
        user_id: String.to_integer(user_id),
        team_id: String.to_integer(team_id)
      )

    Logger.debug(inspect(membership))

    case Repo.delete(membership) do
      {:ok, _} ->
        conn
        |> json(%{ok: true})

      {:error, _} ->
        conn
        |> json(%{ok: false})
    end
  end
end
