SHELL=/bin/sh

export COMPOSE_DOCKER_CLI_BUILD=1
export BUILDKIT_PROGRESS=tty
export DOCKER_BUILDKIT=1

local:
	docker build \
		-f src/Dockerfile \
		-t man-s4-pyrfc-demo/local \
		--no-cache=false \
		.
	docker run \
		-it --rm \
		--cpus 1 --cpu-shares 1024 --memory 2g \
		-v "$(PWD)":/app:rw \
		man-s4-pyrfc-demo/local