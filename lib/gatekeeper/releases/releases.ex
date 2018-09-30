defmodule Gatekeeper.Releases do
  require Logger

  @moduledoc """
  The Releases context.
  """

  import Ecto.Query, warn: false
  alias Gatekeeper.Repo

  alias Gatekeeper.Releases.Release

  @doc """
  Returns the list of releases.

  ## Examples

      iex> list_releases()
      [%Release{}, ...]

  """
  def list_releases do
    Repo.all(Release)
  end

  @doc """
  Gets a single release.

  Raises `Ecto.NoResultsError` if the Release does not exist.

  ## Examples

      iex> get_release!(123)
      %Release{}

      iex> get_release!(456)
      ** (Ecto.NoResultsError)

  """
  def get_release!(id), do: Repo.get!(Release, id)

  @doc """
  Creates a release.

  ## Examples

      iex> create_release(%{field: value})
      {:ok, %Release{}}

      iex> create_release(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_release(attrs, approvers) do
    release =
      %Release{}
      |> Release.changeset(attrs)

    release =
      release
      |> Repo.insert()

    case release do
      {:ok, release} ->
        release =
          create_release_approvals_from_string(release, approvers)
          |> add_mandatory_approvals()

        {:ok, release}

      release ->
        release
    end
  end

  defp add_mandatory_approvals(release) do
    release =
      release
      |> Repo.preload(:approvals)
      |> Repo.preload(:team)

    current_approvers =
      release.approvals
      |> Enum.map(fn a -> a.user_id end)

    mandatory =
      release.team
      |> Repo.preload(:memberships)
      |> Map.get(:memberships)
      |> Enum.filter(fn m -> m.mandatory_approver end)
      |> Enum.map(fn m -> m.user_id end)

    approvals =
      (mandatory -- current_approvers)
      |> Enum.map(fn user_id ->
        {:ok, approval} =
          create_approval(%{
            release_id: release.id,
            user_id: user_id,
            mandatory: true,
            status: "initial"
          })

        approval
      end)

    release
    |> Map.put(:approvals, release.approvals ++ approvals)
  end

  @doc """
  Updates a release.

  ## Examples

      iex> update_release(release, %{field: new_value})
      {:ok, %Release{}}

      iex> update_release(release, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_release(%Release{} = release, attrs) do
    release
    |> Release.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Release.

  ## Examples

      iex> delete_release(release)
      {:ok, %Release{}}

      iex> delete_release(release)
      {:error, %Ecto.Changeset{}}

  """
  def delete_release(%Release{} = release) do
    Repo.delete(release)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking release changes.

  ## Examples

      iex> change_release(release)
      %Ecto.Changeset{source: %Release{}}

  """
  def change_release(%Release{} = release) do
    Release.changeset(release, %{})
  end

  alias Gatekeeper.Releases.Approval

  @doc """
  Returns the list of release_approvals.

  ## Examples

      iex> list_release_approvals()
      [%Approval{}, ...]

  """
  def list_release_approvals do
    Repo.all(Approval)
  end

  @doc """
  Gets a single approval.

  Raises `Ecto.NoResultsError` if the Approval does not exist.

  ## Examples

      iex> get_approval!(123)
      %Approval{}

      iex> get_approval!(456)
      ** (Ecto.NoResultsError)

  """
  def get_approval!(id), do: Repo.get!(Approval, id)

  @doc """
  Creates a approval.

  ## Examples

      iex> create_approval(%{field: value})
      {:ok, %Approval{}}

      iex> create_approval(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_approval(attrs \\ %{}) do
    %Approval{}
    |> Approval.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a approval.

  ## Examples

      iex> update_approval(approval, %{field: new_value})
      {:ok, %Approval{}}

      iex> update_approval(approval, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_approval(%Approval{} = approval, attrs) do
    approval
    |> Approval.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Approval.

  ## Examples

      iex> delete_approval(approval)
      {:ok, %Approval{}}

      iex> delete_approval(approval)
      {:error, %Ecto.Changeset{}}

  """
  def delete_approval(%Approval{} = approval) do
    Repo.delete(approval)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking approval changes.

  ## Examples

      iex> change_approval(approval)
      %Ecto.Changeset{source: %Approval{}}

  """
  def change_approval(%Approval{} = approval) do
    Approval.changeset(approval, %{})
  end

  def create_release_approvals_from_string(release, approvers) do
    case approvers do
      "" ->
        release

      _ ->
        approvers =
          approvers
          |> String.split(",")
          |> Enum.map(fn s -> String.to_integer(s) end)
          |> Enum.map(fn id -> Gatekeeper.Users.get_user!(id) end)
          |> Enum.map(fn u -> Repo.preload(u, :memberships) end)
          |> Enum.filter(fn u ->
            Gatekeeper.Users.User.has_membership?(u, release.team_id)
          end)

        release =
          Map.put(
            release,
            :approvals,
            approvers
            |> Enum.map(fn approver ->
              membership = Gatekeeper.Users.User.get_membership(approver, release.team_id)

              Logger.debug("Creation empty approval for user #{approver.name}")

              {:ok, approval} =
                create_approval(%{
                  release_id: release.id,
                  user_id: approver.id,
                  status: "initial",
                  mandatory: membership.mandatory_approver
                })

              approval
            end)
          )

        release
    end
  end
end
