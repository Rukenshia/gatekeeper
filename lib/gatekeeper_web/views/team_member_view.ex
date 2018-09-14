defmodule GatekeeperWeb.TeamMemberView do
  use GatekeeperWeb, :view

  alias Gatekeeper.Repo
  alias GatekeeperWeb.UserView

  def render("members.json", %{members: members}) do
    members
    |> Repo.preload(:user)
    |> Enum.map(fn m -> render("membership.json", %{membership: m}) end)
  end

  def render("membership.json", %{membership: membership}) do
    %{
      user_id: membership.user_id,
      team_id: membership.team_id,
      role: membership.role,
      mandatory_approver: membership.mandatory_approver
    }
    |> add_user(membership)
  end

  def add_user(obj, membership) do
    if Ecto.assoc_loaded?(membership.user) do
      obj
      |> Map.put("user", UserView.render("user.json", %{user: membership.user}))
    else
      obj
    end
  end
end
