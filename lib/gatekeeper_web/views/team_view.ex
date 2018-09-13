defmodule GatekeeperWeb.TeamView do
  use GatekeeperWeb, :view

  def get_membership(user, memberships) do
    Enum.find(memberships, fn m -> m.user_id == user.id end)
  end
end
