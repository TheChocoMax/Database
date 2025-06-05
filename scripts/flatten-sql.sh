#!/bin/sh

set -e

# Default directories
SRC_DIR="${1:-.}"
DEST_DIR="${2:-flattened-sql}"

echo "📦 Flattening SQL files from '$SRC_DIR' to '$DEST_DIR'..."

mkdir -p "$DEST_DIR"

find "$SRC_DIR" -type f -name "*.sql" ! -name "*.session.sql" | while read -r file; do
    # Remove leading './' from the file path
    clean_path=$(echo "$file" | sed 's|^\./||')
    # Flatten the path by replacing '/' with '_'
    new_name=$(echo "$clean_path" | sed 's|/|_|g')
    cp "$file" "$DEST_DIR/$new_name"
    echo "✅ Copied: $file → $DEST_DIR/$new_name"
done
