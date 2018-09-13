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
alias Gatekeeper.Releases

Repo.insert!(%Users.User{
  name: "Hubert",
  email: "hubert@fkn.space"
})

Repo.insert!(%Users.User{
  name: "Karolin",
  email: "karolin@fkn.space"
})

Repo.insert!(%Teams.Team{
  name: "jsi"
})

Repo.insert!(%Teams.TeamMember{
  user_id: 1,
  team_id: 1,
  role: "developer",
  mandatory_approver: false
})

Repo.insert!(%Teams.TeamMember{
  user_id: 2,
  team_id: 1,
  role: "administrator",
  mandatory_approver: true
})

Repo.insert!(%Releases.Release{
  team_id: 1,
  commit_hash: "a895fc7",
  description: "A fancy release",
  version: "0.3.9"
})

Repo.insert!(%Releases.Approval{
  release_id: 1,
  user_id: 2,
  status: "initial"
})

Repo.insert!(%Releases.Approval{
  release_id: 1,
  user_id: 1,
  status: "approved"
})
