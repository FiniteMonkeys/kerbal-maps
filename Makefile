.PHONY: help

APP_NAME ?= $(shell mix compile 2>&1 >/dev/null && mix run -e "IO.puts KerbalMaps.MixProject.project() |> Keyword.get(:app)")
APP_VSN ?= $(shell mix compile 2>&1 >/dev/null && mix run -e "IO.puts KerbalMaps.MixProject.project() |> Keyword.get(:version)")

help:
	@echo "$(APP_NAME):$(APP_VSN)"
	@perl -nle'print $& if m{^[a-zA-Z_-]+:.*?## .*$$}' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

build:
	@echo "$(APP_VSN)" > VERSION
	docker build --build-arg APP_NAME=$(APP_NAME) \
        --build-arg APP_VSN=$(APP_VSN) \
        -t $(APP_NAME):$(APP_VSN) \
        -t $(APP_NAME):latest .
	rm VERSION

develop:
	# it's okay to start a container if it's already running
	@docker start postgres
	env_vars=""; while IFS='' read -r line || [[ -n "$$line" ]]; do env_vars="$$env_vars $$line"; done < config/docker.env; eval "$$env_vars mix phx.server"

run:
	docker run --env-file config/docker.env \
        --expose 4000 -p 80:4000 \
        --rm -it $(APP_NAME):latest

deploy:
	# it's okay to start a container if it's already running
	@docker start postgres
	@echo "$(APP_VSN)" > VERSION
	heroku container:push web --arg APP_VSN=$(APP_VSN)
	heroku container:release web
	rm VERSION
