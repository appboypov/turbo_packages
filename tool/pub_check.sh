#!/bin/bash
# pub_check.sh - Validate packages meet 160/160 pub.dev points using pana
#
# This script validates each package in the monorepo to ensure it meets
# pub.dev publication standards. It runs sequentially for clear error reporting.

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Get the package directory from Melos environment variable
PACKAGE_DIR="${MELOS_PACKAGE_PATH:-.}"

if [ ! -f "$PACKAGE_DIR/pubspec.yaml" ]; then
  echo -e "${RED}✖ Error: pubspec.yaml not found in $PACKAGE_DIR${NC}" >&2
  exit 1
fi

PACKAGE_NAME=$(basename "$PACKAGE_DIR")
echo -e "${YELLOW}Checking $PACKAGE_NAME...${NC}"

# Check for required files (Dart conventions - 30 points)
REQUIRED_FILES=("LICENSE" "README.md" "CHANGELOG.md")
MISSING_FILES=()

for file in "${REQUIRED_FILES[@]}"; do
  if [ ! -f "$PACKAGE_DIR/$file" ]; then
    MISSING_FILES+=("$file")
  fi
done

if [ ${#MISSING_FILES[@]} -gt 0 ]; then
  echo -e "${RED}✖ Missing required files: ${MISSING_FILES[*]}${NC}" >&2
  exit 1
fi

# Run pana to check for 160/160 pub points
echo "  Running pana analysis..."

# Ensure pana is available (activate if needed)
if ! dart pub global list | grep -q "^pana "; then
  echo "  Activating pana..."
  dart pub global activate pana > /dev/null 2>&1
fi

# Run pana and capture output
PANA_OUTPUT=$(cd "$PACKAGE_DIR" && dart pub global run pana --no-warning 2>&1) || PANA_EXIT=$?

if [ -n "$PANA_EXIT" ] && [ "$PANA_EXIT" -ne 0 ]; then
  echo -e "${RED}✖ Pana validation failed for $PACKAGE_NAME${NC}" >&2
  echo "$PANA_OUTPUT" >&2
  exit 1
fi

# Extract pub points from pana output
# Pana outputs "Points: XXX/160." at the end
PUB_POINTS=$(echo "$PANA_OUTPUT" | grep -E '^Points:\s+[0-9]+/160\.' | grep -oE '[0-9]+' | head -1 || echo "0")

if [ -z "$PUB_POINTS" ] || [ "$PUB_POINTS" = "0" ]; then
  # Try alternative format: "Total: XXX"
  PUB_POINTS=$(echo "$PANA_OUTPUT" | grep -E 'Total:\s+[0-9]+' | grep -oE '[0-9]+' | head -1 || echo "0")
fi

if [ -z "$PUB_POINTS" ] || [ "$PUB_POINTS" = "0" ]; then
  echo -e "${RED}✖ Failed to extract pub points from pana output for $PACKAGE_NAME${NC}" >&2
  echo "$PANA_OUTPUT" >&2
  exit 1
fi

if [ "$PUB_POINTS" -lt 160 ]; then
  echo -e "${RED}✖ $PACKAGE_NAME scored $PUB_POINTS/160 pub points (required: 160/160)${NC}" >&2
  # Show summary of missing points
  echo "$PANA_OUTPUT" | tail -20 >&2
  exit 1
fi

echo -e "${GREEN}✓ $PACKAGE_NAME: $PUB_POINTS/160 pub points${NC}"
exit 0
