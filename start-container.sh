#!/bin/bash
# Simple utility script to start a PostgreSQL container

DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

PORT=${PORT:-5432}

echo "===> Starting $NAME"
echo ""
echo "Cleaning up..."
docker kill $NAME
docker rm $NAME

#!/bin/bash

echo ""
echo "  Reading the environment from .env-container"
echo "  and then starting the database server via Docker"
echo ""

# build up the list of environment variables to pass to the container
for pair in $(grep -v '^#' .env-container | xargs); do
	key=$(echo $pair | cut -d'=' -f1)
	val=$(echo $pair | cut -d'=' -f2)
	envlist="$envlist -e $key=$val"
    echo "  read $key"
done;


# will start an instance of PostgreSQL with a database named 'toobz' and user named 'admin'
# it will mount the local ./data directory as the PostgreSQL data directory inside the container
# so that it will survive container restarts. It will be created if missing. 
# Don't delete it--that's your database ;)
echo
echo "Starting service..."
echo "  Port: $PORT (host), 5432 (container)"
echo
docker run --name $NAME \
    $envlist \
    -v "$DIR/data:/var/lib/postgresql/data" \
    -e "PGDATA=/var/lib/postgresql/data" \
    -p "$PORT:5432" \
    -d postgres

echo
echo "Done."
