#!/bin/bash
# _common.sh - Shared utilities for pub workflow scripts

# Strict error handling
set -euo pipefail

# Constants
readonly REQUIRED_PUB_POINTS=160
readonly PANA_OUTPUT_TAIL_LINES=20

# Colors for output
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly NC='\033[0m' # No Color

# Logging functions
log_info() {
    echo -e "${BLUE}ℹ${NC} $*"
}

log_success() {
    echo -e "${GREEN}✓${NC} $*"
}

log_warning() {
    echo -e "${YELLOW}⚠${NC} $*" >&2
}

log_error() {
    echo -e "${RED}✖${NC} $*" >&2
}

log_step() {
    echo -e "${YELLOW}→${NC} $*"
}

# Get package directory from Melos environment
get_package_dir() {
    echo "${MELOS_PACKAGE_PATH:-.}"
}

# Get package name from directory
get_package_name() {
    local dir="${1:-$(get_package_dir)}"
    basename "$dir"
}

# Validate package directory exists and has pubspec.yaml
validate_package_dir() {
    local pkg_dir="${1:-$(get_package_dir)}"
    
    if [ ! -d "$pkg_dir" ]; then
        log_error "Package directory does not exist: $pkg_dir"
        return 1
    fi
    
    if [ ! -f "$pkg_dir/pubspec.yaml" ]; then
        log_error "pubspec.yaml not found in $pkg_dir"
        return 1
    fi
    
    return 0
}

# Check for required files
check_required_files() {
    local pkg_dir="${1:-$(get_package_dir)}"
    local missing_files=()
    local required_files=("LICENSE" "README.md" "CHANGELOG.md")
    
    for file in "${required_files[@]}"; do
        if [ ! -f "$pkg_dir/$file" ]; then
            missing_files+=("$file")
        fi
    done
    
    if [ ${#missing_files[@]} -gt 0 ]; then
        log_error "Missing required files: ${missing_files[*]}"
        return 1
    fi
    
    return 0
}

# Ensure pana is available
ensure_pana() {
    if ! dart pub global list 2>/dev/null | grep -q "^pana "; then
        log_step "Activating pana..."
        if ! dart pub global activate pana > /dev/null 2>&1; then
            log_error "Failed to activate pana"
            return 1
        fi
    fi
    return 0
}

# Extract pub points from pana output
extract_pub_points() {
    local pana_output="$1"
    local points
    
    # Try multiple patterns to be robust against pana output changes
    # Pattern 1: "Points: XXX/160."
    points=$(echo "$pana_output" | grep -E '^Points:\s+[0-9]+/160\.' | grep -oE '[0-9]+' | head -1 || echo "")
    
    # Pattern 2: "Points: XXX/160" (without trailing dot)
    if [ -z "$points" ]; then
        points=$(echo "$pana_output" | grep -E '^Points:\s+[0-9]+/160' | grep -oE '[0-9]+' | head -1 || echo "")
    fi
    
    # Pattern 3: "Total: XXX"
    if [ -z "$points" ]; then
        points=$(echo "$pana_output" | grep -E 'Total:\s+[0-9]+' | grep -oE '[0-9]+' | head -1 || echo "")
    fi
    
    # Pattern 4: Look for "XXX/160" anywhere in last 10 lines
    if [ -z "$points" ]; then
        points=$(echo "$pana_output" | tail -10 | grep -oE '[0-9]+/160' | grep -oE '^[0-9]+' | head -1 || echo "")
    fi
    
    echo "${points:-0}"
}

# Detect if package is Flutter or pure Dart
is_flutter_package() {
    local pkg_dir="${1:-$(get_package_dir)}"
    
    # Check if pubspec.yaml has flutter dependency or flutter_test
    if grep -qE "flutter:|flutter_test:" "$pkg_dir/pubspec.yaml" 2>/dev/null; then
        return 0
    fi
    
    # Check if there's a lib/main.dart with Flutter imports (common indicator)
    if [ -f "$pkg_dir/lib/main.dart" ] && grep -qE "^import.*flutter" "$pkg_dir/lib/main.dart" 2>/dev/null; then
        return 0
    fi
    
    return 1
}

# Get appropriate test command for package
get_test_command() {
    local pkg_dir="${1:-$(get_package_dir)}"
    
    if is_flutter_package "$pkg_dir"; then
        echo "flutter test"
    else
        echo "dart test"
    fi
}

# Check dependency freshness
check_dependency_freshness() {
    local pkg_dir="${1:-$(get_package_dir)}"
    local outdated_output
    
    log_step "  Checking dependency freshness..."
    cd "$pkg_dir"
    
    # Run pub outdated to check for outdated dependencies
    # Use --no-dev-dependencies to focus on runtime deps
    if ! outdated_output=$(dart pub outdated --no-dev-dependencies 2>&1); then
        log_warning "Could not check dependency freshness"
        return 0  # Don't fail on this, just warn
    fi
    
    # Check if there are any outdated dependencies (excluding pre-release)
    # pub outdated returns 0 even if there are outdated deps, so we parse output
    if echo "$outdated_output" | grep -qE "can be upgraded|is available"; then
        log_warning "Some dependencies may be outdated"
        log_info "Run 'dart pub outdated' in $pkg_dir for details"
        # Don't fail, just warn - this is informational
    fi
    
    return 0
}
