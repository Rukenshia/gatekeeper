defmodule GatekeeperWeb.TeamMemberView do
  use GatekeeperWeb, :view

  alias Gatekeeper.Repo

  def render("members.json", %{members: members}) do
    members
    |> Repo.preload(:user)
    |> Enum.map(fn m -> Gatekeeper.Teams.TeamMember.safe_json(m) end)
  end
end
