#!/bin/sh
set -e

USERNAME=${USERNAME:-postgres}
PGUSER=${POSTGRES_USER:-postgres}
PGDB=${POSTGRES_DB:-$PGUSER}
PGPASS=${POSTGRES_PASSWORD}

echo "🔒 Ensuring correct permissions..."
chown -R "$USERNAME":"$USERNAME" "$PGDATA" /run/postgresql

# Init DB only if not initialized yet
if [ ! -s "$PGDATA/PG_VERSION" ]; then
    if [ -z "$PGPASS" ]; then
        echo "❌ POSTGRES_PASSWORD is required but not set."
        exit 1
    fi

    echo "🧪 Initializing PostgreSQL data directory..."
    echo "$PGPASS" > /tmp/pwfile
    chmod 600 /tmp/pwfile
    chown "$USERNAME":"$USERNAME" /tmp/pwfile

    initdb -D "$PGDATA" --auth=scram-sha-256 --username="$PGUSER" --pwfile=/tmp/pwfile
    rm /tmp/pwfile

    if [ "$PGDB" != "postgres" ]; then
        echo "🛠️  Creating database '$PGDB'..."
        postgres --single -jE -D "$PGDATA" -k /run/postgresql <<-EOSQL
            CREATE DATABASE "$PGDB" OWNER "$PGUSER";
EOSQL
    fi

    echo "📂 Flattening SQL files..."
    /usr/local/bin/flatten-sql.sh

    echo "⏳ Starting PostgreSQL temporarily to run init-db.sh..."
    postgres -D "$PGDATA" -k /run/postgresql &
    PG_PID=$!

    # Wait until PostgreSQL is ready
    until pg_isready -h /run/postgresql -U "$PGUSER"; do
        echo "⏳ Waiting for PostgreSQL to be ready..."
        sleep 1
    done

    echo "✅ Running init-db.sh script..."
    /usr/local/bin/init-db.sh "$PGUSER" "$PGDB"

    echo "🧼 Stopping temporary PostgreSQL..."
    kill "$PG_PID"
    wait "$PG_PID"
fi

echo "🚀 Starting PostgreSQL..."
postgres -D "$PGDATA" -k /run/postgresql
