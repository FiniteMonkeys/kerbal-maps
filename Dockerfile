##
## build base image
##
FROM elixir:1.7.4-alpine AS base

LABEL project="kerbal_maps"

ENV DOCKER_APP_ROOT=/app MIX_ENV=prod PORT=8080
EXPOSE $PORT
WORKDIR $DOCKER_APP_ROOT
RUN apk update &&                             \
    apk upgrade --no-cache &&                 \
    apk add --no-cache                        \
      bash                                    \
      curl &&                                 \
    addgroup elixir &&                        \
    adduser -G elixir -s /bin/sh -D elixir && \
    chown elixir:elixir $DOCKER_APP_ROOT

##
## get dependencies
##
FROM base AS sidecar

RUN apk add --no-cache     \
      build-base           \
      ca-certificates      \
      gcc                  \
      git                  \
      jq                   \
      make                 \
      nodejs               \
      yarn &&              \
    update-ca-certificates

##
## copy application files
##
FROM sidecar AS application_files

COPY --chown=elixir:elixir . $DOCKER_APP_ROOT
USER elixir

##
## build
##
FROM application_files AS builder

RUN mix local.hex --force
RUN mix local.rebar --force
RUN rm -f config/kerbal-maps.conf
RUN mix do deps.get, deps.compile, compile

RUN cd assets &&    \
    yarn install && \
    yarn deploy &&  \
    cd .. &&        \
    mix phx.digest

RUN mix release

##
## release
##
FROM base AS final

COPY --chown=elixir:elixir --from=builder $DOCKER_APP_ROOT/rel rel

# CMD trap 'exit' INT; /opt/app/bin/${APP_NAME} foreground
ENTRYPOINT ["/app/rel/kerbal_maps/bin/kerbal_maps"]
CMD ["foreground"]
