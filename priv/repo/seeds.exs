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

require Logger

team_member =
  Repo.insert!(%Users.User{
    name: "Hubert",
    email: "hubert@fkn.space"
  })

team_admin =
  Repo.insert!(%Users.User{
    name: "Karolin",
    email: "karolin@fkn.space"
  })

team =
  Repo.insert!(%Teams.Team{
    name: "jsi"
  })

Repo.insert!(%Teams.TeamMember{
  user_id: team_member.id,
  team_id: team.id,
  role: "developer",
  mandatory_approver: false
})

release =
  Repo.insert!(%Releases.Release{
    team_id: team.id,
    commit_hash: "a895fc7",
    description: "A fancy release",
    version: "0.3.9"
  })

Repo.insert!(%Releases.Approval{
  release_id: release.id,
  user_id: team_admin.id,
  status: "initial",
  mandatory: true
})

Repo.insert!(%Releases.Approval{
  release_id: release.id,
  user_id: team_member.id,
  status: "approved",
  mandatory: false
})
