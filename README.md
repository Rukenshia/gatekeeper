# Gatekeeper

## Keycloak Setup

This repository needs a Keycloak installation. A docker-compose file is included.

Keycloak setup:

* Add a new client called gatekeeper
* Make it "confidential"
* Add a role called "jsi"
* Add a mapper that maps all client roles of gatekeeper to "teams"
* Make sure "Full Scope Enabled" is on
* Add your user to the jsi team by assigning the role ("admin", password "admin")

## Getting Started

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.create && mix ecto.migrate`
  * Install Node.js dependencies with `cd assets && npm install`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

