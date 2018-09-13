VERSION ?= 0.1.0

start:
	docker-compose up -d
	mix deps.get
	mix phx.server

upload:
	docker build -t gcr.io/mps-gatekeeper/gatekeeper:${VERSION} .
	docker push gcr.io/mps-gatekeeper/gatekeeper:${VERSION}

deploy:
	kubectl apply -f k8s/deployment.yml

.PHONY: start
