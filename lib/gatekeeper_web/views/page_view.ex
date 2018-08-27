defmodule GatekeeperWeb.PageView do
  use GatekeeperWeb, :view

  def release_team(release, teams) do
    Enum.find(teams, fn t -> t.id == release.team_id end)
  end
end
