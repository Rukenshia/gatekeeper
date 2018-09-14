defmodule GatekeeperWeb.UserView do
  use GatekeeperWeb, :view

  alias GatekeeperWeb.TeamMemberView

  def render("users.json", %{users: users}) do
    users
    |> Enum.map(fn u -> render("user.json", %{user: u}) end)
  end

  def render("user.json", %{user: user}) do
    %{id: user.id, name: user.name, email: user.email}
    |> add_membership(user)
  end

  def add_membership(obj, user) do
    if Ecto.assoc_loaded?(user.memberships) do
      obj
      |> Map.put(
        "membership",
        Enum.map(user.memberships, fn m -> TeamMemberView.render("membership.json", %{membership: m}) end)
      )
    else
      obj
    end
  end
end
