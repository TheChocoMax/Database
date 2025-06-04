#!/bin/sh

set -e

DB_USER="$1"
DB_NAME="$2"

# Drop and recreate the database
echo "Dropping and recreating database '$DB_NAME'..."
dropdb -h /run/postgresql -U "$DB_USER" "$DB_NAME" || true
createdb -h /run/postgresql -U "$DB_USER" "$DB_NAME"

# Execute all flattened SQL files (excluding nested ones)
find flattened-sql -maxdepth 1 -name "*.sql" | while read -r file; do
    echo "Running $file..."
    psql -h /run/postgresql -U "$DB_USER" -d "$DB_NAME" -f "$file"
done

# Delete the flattened-sql directory
rm -rf flattened-sql
