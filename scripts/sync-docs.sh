#!/bin/bash

# Simple script to sync OpenSpec changes to the Documentation Center.
# Usage: ./scripts/sync-docs.sh <change-name>

CHANGE_NAME=$1

if [ -z "$CHANGE_NAME" ]; then
  echo "Usage: ./scripts/sync-docs.sh <change-name>"
  exit 1
fi

DOCS_DIR="docs/src/content/docs/features"
ARCHIVE_DIR="openspec/changes/archive/$(date +%Y-%m-%d)-$CHANGE_NAME"

# Check if archive exists
if [ ! -d "$ARCHIVE_DIR" ]; then
  # Fallback to current changes
  ARCHIVE_DIR="openspec/changes/$CHANGE_NAME"
  if [ ! -d "$ARCHIVE_DIR" ]; then
    echo "Error: Change directory for '$CHANGE_NAME' not found in archive or active changes."
    exit 1
  fi
fi

echo "Syncing '$CHANGE_NAME' to Documentation Center..."

# Append Proposal and Design to a single feature doc
FILE_PATH="$DOCS_DIR/$CHANGE_NAME.md"

{
  echo "---"
  echo "title: Feature Spec - $CHANGE_NAME"
  echo "---"
  echo ""
  echo "# Proposal"
  cat "$ARCHIVE_DIR/proposal.md"
  echo ""
  echo "# Design"
  cat "$ARCHIVE_DIR/design.md"
} > "$FILE_PATH"

echo "Done! Finalized documentation available at: $FILE_PATH"
