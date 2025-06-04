#!/bin/sh

set -e

DB_USER="$1"
DB_NAME="$2"

# Drop all public tables
psql -h /run/postgresql -U "$DB_USER" -d "$DB_NAME" -c "
DO \$\$ 
DECLARE 
    r RECORD;
BEGIN 
    FOR r IN (SELECT tablename FROM pg_tables WHERE schemaname = 'public') 
    LOOP 
        EXECUTE 'DROP TABLE IF EXISTS ' || quote_ident(r.tablename) || ' CASCADE';
    END LOOP; 
END 
\$\$;
"

# Execute all flattened SQL files
for file in flattened-sql/*.sql; do
    echo "Running $file..."
    psql -h /run/postgresql -U "$DB_USER" -d "$DB_NAME" -f "$file"
done

# Delete the flattened-sql directory
rm -rf flattened-sql
