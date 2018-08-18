defmodule GatekeeperWeb.UserView do
  use GatekeeperWeb, :view

  def render("users.json", %{users: users}) do
    users
    |> Enum.map(fn u -> Gatekeeper.Users.User.safe_json(u) end)
  end
end
