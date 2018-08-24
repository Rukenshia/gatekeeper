# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Gatekeeper.Repo.insert!(%Gatekeeper.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
alias Gatekeeper.Repo
alias Gatekeeper.Teams
alias Gatekeeper.Users

Repo.insert!(%Users.User{
  id: 1,
  name: "Hubert",
  email: "hubert@fkn.space"
})

Repo.insert!(%Users.User{
  id: 2,
  name: "Karolin",
  email: "karolin@fkn.space"
})

Repo.insert!(%Teams.Team{
  id: 1,
  name: "JSI"
})

Repo.insert!(%Teams.TeamMember{
  user_id: 2,
  team_id: 1,
  role: "administrator"
})
