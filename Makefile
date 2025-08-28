include .env
DOCKER_BUILD_COMMAND=docker build --file Dockerfile --no-cache --platform linux/amd64 --tag $(APP_DOCKER_TAG)

run:
	bin/rr serve

up:
	$(DOCKER_BUILD_COMMAND) --build-arg APP_ENV=dev .
	docker compose --env-file .env up

