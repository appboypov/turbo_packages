#!/bin/bash
# Install git hooks from tool/hooks/ to .git/hooks/

set -e

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
HOOKS_SOURCE="$REPO_ROOT/tool/hooks"
HOOKS_TARGET="$REPO_ROOT/.git/hooks"

if [ ! -d "$HOOKS_SOURCE" ]; then
  echo "Error: Hooks source directory not found: $HOOKS_SOURCE"
  exit 1
fi

if [ ! -d "$HOOKS_TARGET" ]; then
  echo "Error: Git hooks directory not found: $HOOKS_TARGET"
  echo "This script must be run from within a git repository."
  exit 1
fi

echo "Installing git hooks..."

# Copy each hook from tool/hooks/ to .git/hooks/
for hook in "$HOOKS_SOURCE"/*; do
  if [ -f "$hook" ] && [ -x "$hook" ]; then
    hook_name=$(basename "$hook")
    target_hook="$HOOKS_TARGET/$hook_name"
    
    # Copy the hook
    cp "$hook" "$target_hook"
    chmod +x "$target_hook"
    
    echo "✓ Installed hook: $hook_name"
  fi
done

echo "✓ All hooks installed successfully"
