defmodule GatekeeperWeb.TeamController do
  require Logger

  use GatekeeperWeb, :controller

  alias Gatekeeper.Repo
  alias Gatekeeper.Teams
  alias Gatekeeper.Users
  alias Gatekeeper.Teams.Team

  def index(conn, _params) do
    teams = Teams.list_teams()
    render(conn, "index.html", teams: teams)
  end

  def new(conn, _params) do
    changeset = Teams.change_team(%Team{})
    render(conn, "new.html", changeset: changeset)
  end

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
    team = Teams.get_team!(id)
    render(conn, "show.html", team: team)
  end

  def edit(conn, %{"id" => id}) do
    team =
      Teams.get_team!(id)
      |> Repo.preload(:members)

    users =
      Users.list_users()
      |> Repo.preload(:teams)

    changeset = Teams.change_team(team)
    render(conn, "edit.html", team: team, changeset: changeset, users: users, vue_data: Poison.encode!(Team.safe_json(team), pretty: true))
  end

  def update(conn, %{"id" => id, "team" => team_params}) do
    team = Teams.get_team!(id)

    case Teams.update_team(team, team_params) do
      {:ok, team} ->
        conn
        |> put_flash(:info, "Team updated successfully.")
        |> redirect(to: team_path(conn, :show, team))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", team: team, changeset: changeset, vue_data: Poison.encode!(team.safe_json(team)))
    end
  end

  def delete(conn, %{"id" => id}) do
    team = Teams.get_team!(id)
    {:ok, _team} = Teams.delete_team(team)

    conn
    |> put_flash(:info, "Team deleted successfully.")
    |> redirect(to: team_path(conn, :index))
  end

  def add_member(conn, %{"team_id" => id, "user" => user_id}) do
    team = Teams.get_team!(id)
    # user = Users.get_user!(user_id)

    changeset =
      Teams.TeamMember.changeset(%Teams.TeamMember{}, %{
        user_id: user_id,
        team_id: String.to_integer(id),
        role: "administrator"
      })

    case Repo.insert_or_update(changeset) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "Team updated successfully.")
        |> redirect(to: team_path(conn, :edit, team))

      {:error, _} ->
        conn
        |> put_flash(:error, "Could not add member to team")
        |> redirect(to: team_path(conn, :edit, team))
    end
  end

  def api_remove_member(conn, %{"team_id" => team_id, "user_id" => user_id}) do
    membership =
      Repo.get_by!(
        Gatekeeper.Teams.TeamMember,
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
