defmodule GatekeeperWeb.TeamController do
  require Logger

  use GatekeeperWeb, :controller

  alias Gatekeeper.Repo
  alias Gatekeeper.Teams
  alias Gatekeeper.Teams.Team

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

  def show(conn, %{"id" => id}) do
    team =
      Teams.get_team!(id)
      |> Repo.preload(:members)
      |> Repo.preload(:memberships)
      |> Repo.preload(:releases)

    render(conn, "show.html", team: team)
  end

  def edit(conn, %{"id" => id}) do
    team = Teams.get_team!(id)

    render(conn, "edit.html",
      team: team,
      vue_data: Poison.encode!(%{team: Team.safe_json(team)}, pretty: true)
    )
  end
end
