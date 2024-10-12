#!/bin/sh

set -e

echo "Installing app's dependencies..."
mix deps.get

echo "Compiling files..."
mix compile

# Wait for Postgres to become available.
while ! pg_isready -q -h $DB_HOST -U $DB_USER
do
  echo "Postgres is unavailable - sleeping"
  sleep 1
done

echo "Postgres is available: continuing with database setup..."
mix ecto.setup

echo "Testing the application..."
mix credo --strict
mix test

echo "Launching Phoenix web server..."
mix phx.server
