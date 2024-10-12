# Prepare build image
FROM elixir:1.14.2-alpine

# Install container dependencies
RUN apk update && \
    apk upgrade --no-cache && \
    apk add sudo && \
    apk add bash && \
    apk add openssl && \
    apk add postgresql-client

# Create an app directory to store our files in
ENV APP_HOME /app
RUN mkdir $APP_HOME
WORKDIR $APP_HOME
COPY mix.exs mix.lock ./run.sh ./

# Install the Phoenix (phx) archive
RUN mix local.hex --force && \
    mix local.rebar --force && \
    mix archive.install hex phx_new --force

# Expose port 4000
EXPOSE 4000
