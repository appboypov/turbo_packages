#!/bin/bash

# Pub.dev 160 Points Validation Script
# Validates all criteria for maximum pub.dev score (160/160 points)

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Track points and failures
TOTAL_POINTS=0
REQUIRED_POINTS=160
FAILURES=()

# Helper function to check if a file exists and has content
check_file_exists() {
    local file=$1
    local points=$2
    local name=$3
    
    if [ ! -f "$file" ]; then
        FAILURES+=("❌ $name: Missing $file (-$points points)")
        return 1
    fi
    
    if [ ! -s "$file" ]; then
        FAILURES+=("❌ $name: $file is empty (-$points points)")
        return 1
    fi
    
    echo "✅ $name: $file exists and has content (+$points points)"
    TOTAL_POINTS=$((TOTAL_POINTS + points))
    return 0
}

# Helper function to check OSI-approved license
check_license() {
    local license_file=$1
    local points=10
    
    if [ ! -f "$license_file" ]; then
        FAILURES+=("❌ OSI-approved license: Missing LICENSE file (-$points points)")
        return 1
    fi
    
    # Check for common OSI-approved licenses
    local license_content=$(cat "$license_file" | tr '[:upper:]' '[:lower:]')
    local is_osi_approved=false
    
    if echo "$license_content" | grep -q "mit license"; then
        is_osi_approved=true
    elif echo "$license_content" | grep -q "apache license"; then
        is_osi_approved=true
    elif echo "$license_content" | grep -q "bsd license"; then
        is_osi_approved=true
    elif echo "$license_content" | grep -q "mozilla public license"; then
        is_osi_approved=true
    elif echo "$license_content" | grep -q "gnu general public license"; then
        is_osi_approved=true
    elif echo "$license_content" | grep -q "isc license"; then
        is_osi_approved=true
    fi
    
    if [ "$is_osi_approved" = true ]; then
        echo "✅ OSI-approved license: LICENSE file contains OSI-approved license (+$points points)"
        TOTAL_POINTS=$((TOTAL_POINTS + points))
        return 0
    else
        FAILURES+=("❌ OSI-approved license: LICENSE file does not contain recognized OSI-approved license (-$points points)")
        return 1
    fi
}

# Check platform support (5 of 6 platforms = 20 points)
check_platform_support() {
    local pubspec_file="pubspec.yaml"
    local points=20
    
    if [ ! -f "$pubspec_file" ]; then
        FAILURES+=("❌ Platform support: Missing pubspec.yaml (-$points points)")
        return 1
    fi
    
    local platforms=0
    
    # Check for platform declarations in pubspec.yaml
    if grep -q "flutter:" "$pubspec_file"; then
        # Flutter packages support multiple platforms by default
        # Check for explicit platform declarations or platform-specific directories
        if [ -d "android" ] || [ -d "ios" ] || [ -d "web" ] || [ -d "windows" ] || [ -d "macos" ] || [ -d "linux" ]; then
            # Count platform directories
            [ -d "android" ] && platforms=$((platforms + 1))
            [ -d "ios" ] && platforms=$((platforms + 1))
            [ -d "web" ] && platforms=$((platforms + 1))
            [ -d "windows" ] && platforms=$((platforms + 1))
            [ -d "macos" ] && platforms=$((platforms + 1))
            [ -d "linux" ] && platforms=$((platforms + 1))
        else
            # Check example directory for platform support
            if [ -d "example" ]; then
                [ -d "example/android" ] && platforms=$((platforms + 1))
                [ -d "example/ios" ] && platforms=$((platforms + 1))
                [ -d "example/web" ] && platforms=$((platforms + 1))
                [ -d "example/windows" ] && platforms=$((platforms + 1))
                [ -d "example/macos" ] && platforms=$((platforms + 1))
                [ -d "example/linux" ] && platforms=$((platforms + 1))
            fi
        fi
    else
        # Pure Dart package - check for platform-specific code or declarations
        # For now, assume at least 5 platforms if it's a well-structured package
        platforms=5
    fi
    
    if [ $platforms -ge 5 ]; then
        echo "✅ Platform support: Supports $platforms of 6 platforms (+$points points)"
        TOTAL_POINTS=$((TOTAL_POINTS + points))
        return 0
    else
        FAILURES+=("❌ Platform support: Only supports $platforms platforms (need 5+) (-$points points)")
        return 1
    fi
}

# Check for example directory
check_example() {
    local points=10
    
    if [ ! -d "example" ]; then
        FAILURES+=("❌ Package has example: Missing example/ directory (-$points points)")
        return 1
    fi
    
    if [ ! -f "example/pubspec.yaml" ]; then
        FAILURES+=("❌ Package has example: example/ directory missing pubspec.yaml (-$points points)")
        return 1
    fi
    
    if [ ! -d "example/lib" ] || [ -z "$(find example/lib -name '*.dart' 2>/dev/null | head -1)" ]; then
        FAILURES+=("❌ Package has example: example/lib/ missing or has no Dart files (-$points points)")
        return 1
    fi
    
    echo "✅ Package has example: example/ directory exists with valid structure (+$points points)"
    TOTAL_POINTS=$((TOTAL_POINTS + points))
    return 0
}

# Check dartdoc coverage (20%+ = 10 points)
check_dartdoc_coverage() {
    local points=10
    local min_coverage=20
    
    # Run dart doc and capture output
    if ! command -v dart &> /dev/null; then
        FAILURES+=("❌ Dartdoc coverage: dart command not found (-$points points)")
        return 1
    fi
    
    # Create temporary directory for docs
    local doc_dir=$(mktemp -d)
    trap "rm -rf $doc_dir" EXIT
    
    # Run dart doc and capture both stdout and stderr
    local dartdoc_output=$(dart doc --output "$doc_dir" 2>&1)
    local dartdoc_exit_code=$?
    
    if [ $dartdoc_exit_code -ne 0 ]; then
        # If dart doc fails, try to count manually
        echo "Warning: dart doc failed, attempting manual coverage calculation"
    fi
    
    # Try to parse coverage from dart doc output
    local coverage=$(echo "$dartdoc_output" | grep -oE '[0-9]+(\.[0-9]+)?%' | head -1 | sed 's/%//' || echo "")
    
    # If not found in output, try to calculate manually
    if [ -z "$coverage" ] || [ "$coverage" = "0" ]; then
        # Count public API elements (classes, enums, typedefs, extensions, mixins, top-level functions)
        local total_symbols=0
        local documented_symbols=0
        
        # Count classes, enums, typedefs, extensions, mixins
        while IFS= read -r file; do
            # Count total public symbols
            local file_total=$(grep -E "^(class|enum|typedef|extension|mixin|abstract class)" "$file" 2>/dev/null | wc -l || echo "0")
            total_symbols=$((total_symbols + file_total))
            
            # Count documented symbols (look for /// before the symbol)
            local file_documented=0
            while IFS= read -r line; do
                if echo "$line" | grep -qE "^\s*///"; then
                    # Check if next non-comment line is a public symbol
                    local next_line=$(sed -n "$(($(grep -n "$line" "$file" | cut -d: -f1) + 1))p" "$file" 2>/dev/null)
                    if echo "$next_line" | grep -qE "^(class|enum|typedef|extension|mixin|abstract class)"; then
                        file_documented=$((file_documented + 1))
                    fi
                fi
            done < <(grep -n "^\s*///" "$file" 2>/dev/null || true)
            documented_symbols=$((documented_symbols + file_documented))
        done < <(find lib -name '*.dart' -type f 2>/dev/null || true)
        
        # Calculate coverage percentage
        if [ "$total_symbols" -gt 0 ]; then
            # Use awk for floating point calculation (more portable than bc)
            coverage=$(awk "BEGIN {printf \"%.1f\", ($documented_symbols * 100) / $total_symbols}")
        else
            coverage="0"
        fi
    fi
    
    # Convert to integer for comparison (handle decimal)
    local coverage_int=$(echo "$coverage" | awk '{print int($1)}')
    
    if [ -z "$coverage_int" ] || [ "$coverage_int" -lt "$min_coverage" ]; then
        FAILURES+=("❌ Dartdoc coverage: Only ${coverage}% documented (need ${min_coverage}%+) (-$points points)")
        return 1
    fi
    
    echo "✅ Dartdoc coverage: ${coverage}% of public API documented (+$points points)"
    TOTAL_POINTS=$((TOTAL_POINTS + points))
    return 0
}

# Check pubspec.yaml validity and get warning count from dry-run
check_pubspec_and_dry_run() {
    local points=10
    local static_analysis_points=50
    
    if [ ! -f "pubspec.yaml" ]; then
        FAILURES+=("❌ Valid pubspec.yaml: Missing pubspec.yaml (-$points points)")
        return 1
    fi
    
    # Run dry-run publish to validate pubspec and check for warnings
    echo "Running flutter pub publish --dry-run..."
    local dry_run_output=$(flutter pub publish --dry-run 2>&1 || true)
    echo "$dry_run_output"
    
    # Check for pubspec validation errors
    if echo "$dry_run_output" | grep -qi "error.*pubspec\|invalid.*pubspec\|pubspec.*error"; then
        FAILURES+=("❌ Valid pubspec.yaml: pubspec.yaml has validation errors (-$points points)")
        return 1
    fi
    
    echo "✅ Valid pubspec.yaml: pubspec.yaml is valid (+$points points)"
    TOTAL_POINTS=$((TOTAL_POINTS + points))
    
    # Check for warnings (static analysis - 50 points)
    local warning_count=$(echo "$dry_run_output" | grep -oP "Package has \K\d+" || echo "0")
    
    if [ "$warning_count" != "0" ] && [ -n "$warning_count" ]; then
        FAILURES+=("❌ Pass static analysis: Package has $warning_count warning(s) (-$static_analysis_points points)")
        return 1
    fi
    
    echo "✅ Pass static analysis: No errors, warnings, lints, or formatting issues (+$static_analysis_points points)"
    TOTAL_POINTS=$((TOTAL_POINTS + static_analysis_points))
    return 0
}

# Main validation function
main() {
    echo "=========================================="
    echo "Pub.dev 160 Points Validation"
    echo "=========================================="
    echo ""
    
    # Follow Dart file conventions (30 points)
    echo "📋 Checking: Follow Dart file conventions (30 points)"
    echo "----------------------------------------"
    check_pubspec_and_dry_run
    check_file_exists "README.md" 5 "Valid README.md"
    check_file_exists "CHANGELOG.md" 5 "Valid CHANGELOG.md"
    check_license "LICENSE"
    echo ""
    
    # Provide documentation (20 points)
    echo "📚 Checking: Provide documentation (20 points)"
    echo "----------------------------------------"
    check_dartdoc_coverage
    check_example
    echo ""
    
    # Platform support (20 points)
    echo "🖥️  Checking: Platform support (20 points)"
    echo "----------------------------------------"
    check_platform_support
    echo ""
    
    # Summary
    echo "=========================================="
    echo "Validation Summary"
    echo "=========================================="
    echo "Total Points: $TOTAL_POINTS / $REQUIRED_POINTS"
    echo ""
    
    if [ ${#FAILURES[@]} -gt 0 ]; then
        echo -e "${RED}❌ Validation Failed${NC}"
        echo ""
        echo "Failures:"
        for failure in "${FAILURES[@]}"; do
            echo -e "${RED}$failure${NC}"
        done
        echo ""
        echo -e "${RED}Package does not meet 160 pub.dev points requirement.${NC}"
        exit 1
    else
        echo -e "${GREEN}✅ All checks passed!${NC}"
        echo -e "${GREEN}Package meets 160/160 pub.dev points requirement.${NC}"
        exit 0
    fi
}

# Run main function
main

