defmodule GatekeeperWeb.TeamView do
  use GatekeeperWeb, :view

  alias GatekeeperWeb.TeamMemberView

  def get_membership(user, memberships) do
    Enum.find(memberships, fn m -> m.user_id == user.id end)
  end

  def render("team.json", %{team: team}) do
    %{
      id: team.id,
      name: team.name
    }
    |> add_memberships(team)
  end

  def add_memberships(obj, team) do
    if Ecto.assoc_loaded?(team.memberships) do
      obj
      |> Map.put(
        "memberships",
        Enum.map(team.memberships, fn m -> TeamMemberView.render("membership.json", %{membership: m}) end)
      )
    else
      obj
    end
  end
end
