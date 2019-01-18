.PHONY: help

APP_NAME ?= `mix run -e "IO.puts KerbalMaps.MixProject.project() |> Keyword.get(:app)"`
APP_VSN ?= `mix run -e "IO.puts KerbalMaps.MixProject.project() |> Keyword.get(:version)"`

help:
	@echo "$(APP_NAME):$(APP_VSN)"
	@perl -nle'print $& if m{^[a-zA-Z_-]+:.*?## .*$$}' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

build:
	@echo "$(APP_VSN)" > VERSION
	@docker build --build-arg APP_NAME=$(APP_NAME) \
        --build-arg APP_VSN=$(APP_VSN) \
        -t $(APP_NAME):$(APP_VSN) \
        -t $(APP_NAME):latest .
	@rm VERSION

run:
	@docker run --env-file config/docker.env \
        --expose 4000 -p 80:4000 \
        --rm -it $(APP_NAME):latest

tag:
	@echo 'Run `git tag --annotate 0.1.1 --message "version 0.1.1"`.'

deploy:
	@heroku container:push web
	@heroku container:release web
