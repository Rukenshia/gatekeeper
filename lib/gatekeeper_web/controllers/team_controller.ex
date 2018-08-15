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
      |> Enum.filter(fn x -> !Gatekeeper.Users.User.is_member_of(x, team) end)
      |> Enum.map(fn x -> Gatekeeper.Users.User.safe_json(x) end)

    changeset = Teams.change_team(team)

    render(conn, "edit.html",
      team: team,
      changeset: changeset,
      vue_data: Poison.encode!(%{team: Team.safe_json(team), users: users}, pretty: true)
    )
  end

  def update(conn, %{"id" => id, "team" => team_params}) do
    team = Teams.get_team!(id)

    users =
      Users.list_users()
      |> Repo.preload(:teams)
      |> Enum.filter(fn x -> !Gatekeeper.Users.User.is_member_of(x, team) end)
      |> Enum.map(fn x -> Gatekeeper.Users.User.safe_json(x) end)

    case Teams.update_team(team, team_params) do
      {:ok, team} ->
        conn
        |> put_flash(:info, "Team updated successfully.")
        |> redirect(to: team_path(conn, :show, team))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html",
          team: team,
          changeset: changeset,
          vue_data: Poison.encode!(%{team: Team.safe_json(team), users: users}, pretty: true)
        )
    end
  end

  def delete(conn, %{"id" => id}) do
    team = Teams.get_team!(id)
    {:ok, _team} = Teams.delete_team(team)

    conn
    |> put_flash(:info, "Team deleted successfully.")
    |> redirect(to: team_path(conn, :index))
  end

  def api_add_member(conn, %{"team_id" => id, "user_id" => user_id}) do
    changeset =
      Teams.TeamMember.changeset(%Teams.TeamMember{}, %{
        user_id: user_id,
        team_id: String.to_integer(id),
        role: "administrator"
      })

    case Repo.insert_or_update(changeset) do
      {:ok, _} ->
        conn
        |> json(%{ok: true})

      {:error, _} ->
        conn
        |> json(%{ok: false})
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
