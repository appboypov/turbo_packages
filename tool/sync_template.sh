#!/bin/bash
# Sync turbo_template to external repository
# Usage: ./sync_template.sh [target_directory]
# Default target: ~/Repos/turbo-template

set -e

# Get target directory from env var or use default
TARGET_DIR="${SYNC_TEMPLATE_TARGET:-$HOME/Repos/turbo-template}"
SOURCE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/turbo_template"

if [ ! -d "$SOURCE_DIR" ]; then
  echo "Error: Source directory not found: $SOURCE_DIR"
  exit 1
fi

echo "Syncing template from $SOURCE_DIR to $TARGET_DIR..."

# Create target directory if it doesn't exist
mkdir -p "$TARGET_DIR"

# Use rsync to copy files, excluding build artifacts and git directory
rsync -av --delete \
  --exclude='build/' \
  --exclude='.dart_tool/' \
  --exclude='node_modules/' \
  --exclude='Pods/' \
  --exclude='.gradle/' \
  --exclude='*.lock' \
  --exclude='.firebase/' \
  --exclude='coverage/' \
  --exclude='.idea/' \
  --exclude='.vscode/' \
  --exclude='.DS_Store' \
  --exclude='.git/' \
  "$SOURCE_DIR/" "$TARGET_DIR/"

echo "✓ Template synced successfully to $TARGET_DIR"
