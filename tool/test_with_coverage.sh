#!/bin/bash
# test_with_coverage.sh - Run tests with coverage display
#
# This script runs tests with coverage and displays a formatted summary.
# Used by melos test script to ensure coverage is always displayed.

# Source common utilities
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=./_common.sh
if ! source "$SCRIPT_DIR/_common.sh"; then
    echo "Error: Failed to source _common.sh from $SCRIPT_DIR" >&2
    exit 1
fi

# Get package directory and name
PACKAGE_DIR=$(get_package_dir)
PACKAGE_NAME=$(get_package_name "$PACKAGE_DIR")

# Validate package directory
if ! validate_package_dir "$PACKAGE_DIR"; then
    exit 1
fi

# Change to package directory
cd "$PACKAGE_DIR" || exit 1

# Run tests with coverage
flutter test --coverage=coverage

# Format coverage if coverage directory exists and has files
# Use set +e to allow coverage formatting to fail without failing the test
set +e
if [ -d coverage ] && [ -n "$(ls -A coverage 2>/dev/null)" ]; then
    # Format coverage to LCOV
    dart run coverage:format_coverage --lcov --in=coverage --out=coverage/lcov.info --report-on=lib 2>/dev/null
    if [ -f coverage/lcov.info ]; then
        echo ""
        echo "📊 Coverage Summary for $PACKAGE_NAME:"
        cat coverage/lcov.info | awk '/^SF:/{gsub(/.*\/lib\//, "lib/", $$0); f=$$0}/^LF:/{lf=substr($$0,4)}/^LH:/{lh=substr($$0,4); if(f !~ /\.g\.dart$$/) {pct=(lf>0)?lh/lf*100:0; printf "  %-60s %5.1f%% (%d/%d)\n", f, pct, lh, lf; total_lh+=lh; total_lf+=lf}}END{pct=(total_lf>0)?total_lh/total_lf*100:0; printf "\n  %-60s %5.1f%% (%d/%d)\n", "TOTAL", pct, total_lh, total_lf}'
        rm -rf coverage/
    fi
fi
set -e
