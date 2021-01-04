FROM elixir:1.10.1-slim

# basic dependencies to make it all work
RUN apt-get update -qq && apt-get -y --allow-unauthenticated install curl libpq-dev postgresql-client git make erlang-crypto apt-transport-https

COPY . .

RUN mix local.hex --force
RUN mix local.rebar --force

