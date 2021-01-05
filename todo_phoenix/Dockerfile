FROM elixir:1.10.1-slim

# basic dependencies to make it all work
RUN apt-get update -qq && apt-get -y --allow-unauthenticated install curl libpq-dev postgresql-client git make erlang-crypto apt-transport-https

COPY . .

RUN mix local.hex --force
RUN mix local.rebar --force
RUN mix phx.gen.secret

ENV MIX_ENV=prod
ENV DATABASE_URL=ecto://postgres:postgres@db/todo_phoenix_prod
ENV SECRET_KEY_BASE='fXDLD2luZksjk1s8S/s29uooMwc2jkJ3sAltVUSulhpNja54EbLP69ZxJLZpmZ97ke5Ph92535qEfA/g/8UKTQ=='

RUN mix deps.update mime
RUN mix compile
