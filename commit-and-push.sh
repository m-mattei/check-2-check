#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

COMMIT_MSG="${1:-Agent: code changes $(date '+%Y-%m-%d %H:%M')}"
PUSH="${2:-true}"

echo "=== Checking for changes ==="
git status --short

if [ -z "$(git status --short)" ]; then
  echo "No changes to commit"
  exit 0
fi

echo "=== Committing changes ==="
git add -A
git commit -m "$COMMIT_MSG"

if [ "$PUSH" = "true" ]; then
  echo "=== Pushing to remote ==="
  git push
  echo "=== Done! Changes pushed ==="
else
  echo "=== Committed locally (push disabled) ==="
fi
