#!/bin/bash
# pub_publish.sh - Validate and publish packages to pub.dev
#
# This script validates packages and publishes them to pub.dev.
# Supports --dry-run flag for validation without publishing.
# Requires --confirmed flag for actual publishing.

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Parse arguments
DRY_RUN=false
CONFIRMED=false

for arg in "$@"; do
  case $arg in
    --dry-run)
      DRY_RUN=true
      shift
      ;;
    --confirmed)
      CONFIRMED=true
      shift
      ;;
    *)
      # Unknown option
      ;;
  esac
done

# Get the package directory from Melos environment variable
PACKAGE_DIR="${MELOS_PACKAGE_PATH:-.}"

if [ ! -f "$PACKAGE_DIR/pubspec.yaml" ]; then
  echo -e "${RED}✖ Error: pubspec.yaml not found in $PACKAGE_DIR${NC}" >&2
  exit 1
fi

PACKAGE_NAME=$(basename "$PACKAGE_DIR")

# First, run pub-check validation
echo -e "${YELLOW}Validating $PACKAGE_NAME before publishing...${NC}"

# Run the pub_check script
if [ -n "$MELOS_ROOT_PATH" ]; then
  PUB_CHECK_SCRIPT="$MELOS_ROOT_PATH/tool/pub_check.sh"
else
  PUB_CHECK_SCRIPT="$(dirname "$0")/pub_check.sh"
fi

"$PUB_CHECK_SCRIPT" || {
  echo -e "${RED}✖ Validation failed. Cannot publish $PACKAGE_NAME${NC}" >&2
  exit 1
}

# If dry-run, just run dart pub publish --dry-run
if [ "$DRY_RUN" = true ]; then
  echo -e "${YELLOW}Running dry-run publish for $PACKAGE_NAME...${NC}"
  cd "$PACKAGE_DIR"
  dart pub publish --dry-run || {
    echo -e "${RED}✖ Dry-run publish failed for $PACKAGE_NAME${NC}" >&2
    exit 1
  }
  echo -e "${GREEN}✓ Dry-run publish successful for $PACKAGE_NAME${NC}"
  exit 0
fi

# For actual publishing, require --confirmed flag
if [ "$CONFIRMED" != true ]; then
  echo -e "${RED}✖ Publishing requires --confirmed flag${NC}" >&2
  echo "  Use: melos pub-publish (which includes --confirmed)" >&2
  echo "  Or use: melos pub-publish-dry-run for validation only" >&2
  exit 1
fi

# Check if we're in CI (should not publish in CI)
if [ -n "$CI" ]; then
  echo -e "${RED}✖ Publishing is not allowed in CI environments${NC}" >&2
  echo "  Use melos pub-check for CI validation" >&2
  exit 1
fi

# Actual publish
echo -e "${YELLOW}Publishing $PACKAGE_NAME to pub.dev...${NC}"
cd "$PACKAGE_DIR"
dart pub publish || {
  echo -e "${RED}✖ Publishing failed for $PACKAGE_NAME${NC}" >&2
  exit 1
}

echo -e "${GREEN}✓ Successfully published $PACKAGE_NAME to pub.dev${NC}"
exit 0
