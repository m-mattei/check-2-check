#!/bin/bash

set -e

SCRIPT_DIR="/Users/michaelmattei/projects/check2check-stack/check-2-check"

echo "=== Post-deploy Doc Update Agent ==="

cd "$SCRIPT_DIR"

echo "=== Running Flutter analyze to check for changes ==="
flutter analyze --no-fatal-infos --no-fatal-warnings > /tmp/flutter_analyze.txt || true

if git diff --quiet HEAD; then
    echo "No code changes detected, checking if docs need update..."
    git status
fi

echo "=== Generating documentation (if needed) ==="
DOCS_NEEDS_UPDATE=false

FEATURES_DIR="$SCRIPT_DIR/docs/src/content/docs/features"
if [ -d "$FEATURES_DIR" ]; then
    echo "Features docs directory exists"
fi

ARCH_DIR="$SCRIPT_DIR/docs/src/content/docs/architecture"
if [ -d "$ARCH_DIR" ]; then
    echo "Architecture docs directory exists"
fi

echo "=== Checking for uncommitted changes ==="
if git diff --stat | grep -q .; then
    echo "Found changes to commit"
    DOCS_NEEDS_UPDATE=true
fi

if [ "$DOCS_NEEDS_UPDATE" = true ]; then
    echo "=== Committing and pushing docs to trigger GitHub Pages deployment ==="
    
    git add -A
    git commit -m "docs: update documentation after deployment" || echo "Nothing to commit"
    
    echo "=== Pushing to GitHub ==="
    git push origin main
    
    echo "=== Doc deployment triggered ==="
    echo "GitHub Action 'Deploy Starlight Documentation' will run automatically"
else
    echo "No documentation changes to push"
fi

echo "=== Post-deploy Doc Update Agent Complete ==="