defmodule Gatekeeper.Users do
  @moduledoc """
  The Users context.
  """
  require Logger

  import Ecto.Query, warn: false
  alias Gatekeeper.Repo

  alias Gatekeeper.Users.User

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    Repo.all(User)
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a User.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{source: %User{}}

  """
  def change_user(%User{} = user) do
    User.changeset(user, %{})
  end

  @doc """
  Finds or creates a user from Auth parameters
  """
  def find_or_create_from_auth(auth, teams) do
    Logger.debug("find_or_create_from_auth for #{inspect(auth.info)}")

    case Repo.get_by(User, email: auth.info.email) do
      user when user != nil ->
        user =
          user
          |> Repo.preload(:teams)

        for team <- teams || [] do
          if is_nil(Enum.find(user.teams, fn t -> t.name == team end)) do
            team = Repo.get_by!(Gatekeeper.Teams.Team, name: team)

            %Gatekeeper.Teams.TeamMember{}
            |> Gatekeeper.Teams.TeamMember.changeset(%{
              user_id: user.id,
              team_id: team.id,
              role: "administrator",
              mandatory_approver: true
            })
            |> Repo.insert!()
          end
        end

        {:ok, user}

      nil ->
        Logger.debug("creating user with name #{auth.info.name} and email #{auth.info.email}")

        %User{}
        |> User.changeset(%{name: auth.info.name, email: auth.info.email})
        |> Repo.insert()
    end
  end
end
