#!/usr/bin/env bash
set -euo pipefail

# 1. Find the root of the git repository
# This allows you to run the command from anywhere
GIT_ROOT=$(git rev-parse --show-toplevel 2>/dev/null)

if [ -z "$GIT_ROOT" ]; then
    echo "❌ Error: Not inside a git repository. Cannot determine config root."
    exit 1
fi

# 2. Change to the config directory
cd "$GIT_ROOT"

# 3. Parse arguments (Default to WorkStation)
HOST="${1:-WorkStation}"
MESSAGE="${2:-auto-commit: $(date '+%Y-%m-%d %H:%M:%S')}"

echo "📂 Config Directory: $GIT_ROOT"
echo "🎯 Target Host: $HOST"

# 4. Git Add
echo "🍎 Staging changes..."
git add .

# 5. Git Commit (Only if there are changes)
if ! git diff --quiet || ! git diff --cached --quiet; then
    echo "💾 Committing changes..."
    git commit -m "$MESSAGE"
else
    echo "⚠️  No changes detected, skipping commit."
fi

# 6. NixOS Rebuild
echo "🔨 Rebuilding NixOS..."
sudo nixos-rebuild switch --flake .#$HOST

echo "✅ Done!"