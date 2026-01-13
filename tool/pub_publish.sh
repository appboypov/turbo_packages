#!/bin/bash
# pub_publish.sh - Validate and publish packages to pub.dev
#
# This script validates packages and publishes them to pub.dev.
# Supports --dry-run flag for validation without publishing.
# Requires --confirmed flag for actual publishing.

# Source common utilities
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=./_common.sh
if ! source "$SCRIPT_DIR/_common.sh"; then
    echo "Error: Failed to source _common.sh from $SCRIPT_DIR" >&2
    exit 1
fi

# Parse arguments
DRY_RUN=false
CONFIRMED=false

while [[ $# -gt 0 ]]; do
    case $1 in
        --dry-run)
            DRY_RUN=true
            shift
            ;;
        --confirmed)
            CONFIRMED=true
            shift
            ;;
        *)
            log_warning "Unknown option: $1"
            shift
            ;;
    esac
done

# Get package directory and name
PACKAGE_DIR=$(get_package_dir)
PACKAGE_NAME=$(get_package_name "$PACKAGE_DIR")

# Validate package directory
if ! validate_package_dir "$PACKAGE_DIR"; then
    exit 1
fi

# First, run pub-check validation
log_step "Validating $PACKAGE_NAME before publishing..."

# Run the pub_check script
if [ -n "${MELOS_ROOT_PATH:-}" ]; then
    PUB_CHECK_SCRIPT="$MELOS_ROOT_PATH/tool/pub_check.sh"
else
    PUB_CHECK_SCRIPT="$SCRIPT_DIR/pub_check.sh"
fi

if ! "$PUB_CHECK_SCRIPT"; then
    log_error "Validation failed. Cannot publish $PACKAGE_NAME"
    exit 1
fi

# If dry-run, just run dart pub publish --dry-run
if [ "$DRY_RUN" = true ]; then
    log_step "Running dry-run publish for $PACKAGE_NAME..."
    cd "$PACKAGE_DIR"
    PUB_OUTPUT=""
    if ! PUB_OUTPUT=$(dart pub publish --dry-run 2>&1); then
        log_error "Dry-run publish failed for $PACKAGE_NAME"
        echo "$PUB_OUTPUT" | tail -30 >&2
        log_info "Run 'dart pub publish --dry-run' in $PACKAGE_DIR for details"
        exit 1
    fi
    log_success "Dry-run publish successful for $PACKAGE_NAME"
    exit 0
fi

# For actual publishing, require --confirmed flag
if [ "$CONFIRMED" != true ]; then
    log_error "Publishing requires --confirmed flag"
    log_info "Use: melos pub-publish (which includes --confirmed)"
    log_info "Or use: melos pub-publish-dry-run for validation only"
    exit 1
fi

# Check if we're in CI (should not publish in CI)
if [ -n "${CI:-}" ]; then
    log_error "Publishing is not allowed in CI environments"
    log_info "Use melos pub-check for CI validation"
    exit 1
fi

# Actual publish
log_step "Publishing $PACKAGE_NAME to pub.dev..."
cd "$PACKAGE_DIR"
if ! dart pub publish; then
    log_error "Publishing failed for $PACKAGE_NAME"
    exit 1
fi

log_success "Successfully published $PACKAGE_NAME to pub.dev"
exit 0
