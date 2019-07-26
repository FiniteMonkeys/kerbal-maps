PROJECT_NAME=kerbal-maps
BUILD_NUMBER ?= DEV
BUILD_SHA ?= $(shell git rev-parse --verify HEAD)
SHORT_BUILD_SHA := $(shell echo $(BUILD_SHA) | head -c 7)
DATE := $(shell date -u "+%Y%m%d")
TAG_NAME := $(DATE)-$(BUILD_NUMBER)-$(SHORT_BUILD_SHA)
DOCKER_TAG := $(PROJECT_NAME):$(TAG_NAME)
DOCKER_TAG_LATEST := $(PROJECT_NAME):latest

develop:
	# it's okay to start a container if it's already running
	@docker start postgres
	env_vars=""; while IFS='' read -r line || [[ -n "$$line" ]]; do env_vars="$$env_vars $$line"; done < config/docker.env; eval "$$env_vars mix phx.server"

build: buildinfo_file version_file
	docker build -t $(DOCKER_TAG) -t $(DOCKER_TAG_LATEST) .

run:
	docker run --env-file config/docker.env --expose 4000 -p 80:4000 --rm -it $(DOCKER_TAG_LATEST)

push:
	docker push $(DOCKER_TAG)

deploy:
	# @echo "$(APP_VSN)" > VERSION
	heroku container:push web # --arg APP_VSN=$(APP_VSN)
	heroku container:release web

clean:
	docker image prune -f --filter 'label=project=$(PROJECT_NAME)' --filter 'until=72h'
	-docker images -qf "reference=$(PROJECT_NAME)*" | xargs docker rmi -f
	rm rel/BUILD-INFO
	rm VERSION

# create_github_release:

buildinfo_file:
	echo "---" > rel/BUILD-INFO
	echo "version: $(TAG_NAME)" >> rel/BUILD-INFO
	echo "build_number: $(BUILD_NUMBER)" >> rel/BUILD-INFO
	echo "git_commit: $(BUILD_SHA)" >> rel/BUILD-INFO
	BUILD_CONTEXT="BuildInfo" \
	BUILD_DESCRIPTION="Build $(TAG_NAME)" \
	test -e rel/BUILD-INFO

version_file:
	echo "$(TAG_NAME)" > VERSION

.PHONY: develop build run push deploy clean buildinfo_file version_file
