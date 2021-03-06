VERSION ?= 0.1.0

start:
	docker-compose up -d
	mix deps.get
	mix phx.server

upload: concourse
	docker build -t gcr.io/mps-gatekeeper/gatekeeper:${VERSION} .
	docker push gcr.io/mps-gatekeeper/gatekeeper:${VERSION}

deploy:
	sed -i "" 's/gatekeeper:.*/gatekeeper:'"${VERSION}"'/g' k8s/deployment.yml
	kubectl apply -f k8s/deployment.yml

concourse:
	cd concourse \
		&& docker build -t "ruken/gatekeeper-resource:${VERSION}" . \
		&& docker tag "ruken/gatekeeper-resource:${VERSION}" "ruken/gatekeeper-resource:latest" \
		&& docker push "ruken/gatekeeper-resource:${VERSION}" \
		&& docker push "ruken/gatekeeper-resource:latest"


.PHONY: start upload deploy concourse
