# Build stage
FROM hexpm/elixir:1.14.5-erlang-25.3-debian-bullseye-20230227-slim as builder

# Install build dependencies
RUN apt-get update -y && apt-get install -y build-essential git \
    && apt-get clean && rm -f /var/lib/apt/lists/*_*

# Set working directory
WORKDIR /app

# Install hex + rebar
RUN mix local.hex --force && \
    mix local.rebar --force

# Copy configuration files
COPY mix.exs mix.lock ./
COPY config config

# Install mix dependencies
RUN mix deps.get --only prod

# Copy all application files
COPY lib lib
COPY priv priv
COPY assets assets

# Compile and build release
ENV MIX_ENV=prod
RUN mix deps.compile
RUN mix assets.deploy
RUN mix compile
RUN mix release

# Release stage
FROM debian:bullseye-slim

RUN apt-get update -y && apt-get install -y libstdc++6 openssl libncurses5 locales \
    && apt-get clean && rm -f /var/lib/apt/lists/*_*

# Set the locale
RUN sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && locale-gen

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

WORKDIR /app

# Copy release from builder
COPY --from=builder /app/_build/prod/rel/creepy_crawlie_cinema_club ./

# Set environment variables
ENV HOME=/app
ENV PORT=8080

CMD ["/app/bin/creepy_crawlie_cinema_club", "start"]