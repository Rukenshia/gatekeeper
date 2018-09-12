start:
	docker-compose up -d
	mix deps.get
	mix phx.server

.PHONY: start
