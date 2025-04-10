# Stage 1: Build
FROM elixir:1.14.4-alpine AS build

# Install build tools
RUN apk add --update --no-cache build-base npm git

WORKDIR /app

# Set environment variable for release build
ENV MIX_ENV=prod

# Cache elixir deps
COPY mix.exs mix.lock ./

# Install Hex and rebar non-interactively
RUN mix local.hex --force && mix local.rebar --force

# Copy the config so that dependencies can be resolved
COPY config config

# Fetch only prod dependencies
RUN mix deps.get --only prod

# Copy the rest of the source and compile
COPY . .
RUN mix compile
RUN mix release

# Stage 2: Run
FROM alpine:3.17.2 AS app
RUN apk add --update --no-cache libstdc++ openssl ncurses

WORKDIR /app

# Copy the release from the build stage
COPY --from=build /app/_build/prod/rel/creepy_crawlie_cinema_club ./

CMD ["bin/creepy_crawlie_cinema_club", "start"]