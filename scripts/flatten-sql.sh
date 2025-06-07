#!/bin/sh

set -e

# Default directories
SRC_DIR="${1:-/docker-entrypoint-initdb.d}"
DEST_DIR="${2:-${FLATTEN_SQL_DIR:-/tmp/flattened-sql}}"

echo "📦 Flattening SQL files from '$SRC_DIR' to '$DEST_DIR'..."

rm -rf "$DEST_DIR"
mkdir -p "$DEST_DIR"

find "$SRC_DIR" -type f -name "*.sql" ! -name "*.session.sql" ! -name "*.test.sql" | while read -r file; do
    rel_path="${file#$SRC_DIR/}"
    new_name=$(echo "$rel_path" | sed 's|/|_|g')
    cp "$file" "$DEST_DIR/$new_name"
    echo "✅ Copied: $file → $DEST_DIR/$new_name"
done
