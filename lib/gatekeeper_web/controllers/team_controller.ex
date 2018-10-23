defmodule GatekeeperWeb.TeamController do
  require Logger

  use GatekeeperWeb, :controller

  alias Gatekeeper.Repo
  alias Gatekeeper.Teams

  def create(conn, %{"team" => team_params}) do
    case Teams.create_team(team_params) do
      {:ok, team} ->
        conn
        |> put_flash(:info, "Team created successfully.")
        |> redirect(to: team_path(conn, :show, team))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"team_id" => team_id}) do
    team =
      Teams.get_team!(team_id)
      |> Repo.preload(:members)
      |> Repo.preload(:memberships)
      |> Repo.preload(:releases)

    team =
      team
      |> Map.put(:releases, Enum.map(team.releases, fn r -> Repo.preload(r, :approvals) end))

    render(conn, "show.html", team: team)
  end

  def edit(conn, %{"team_id" => team_id}) do
    team =
      Teams.get_team!(team_id)
      |> Repo.preload(:members)
      |> Repo.preload(:memberships)

    render(conn, "edit.html", team: team)
  end
end
