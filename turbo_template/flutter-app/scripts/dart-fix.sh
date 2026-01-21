#!/bin/bash

# Change directory to lib
pwd || cd ../lib || exit

# Run flutter pub get
flutter pub get && flutter pub run build_runner build --delete-conflicting-outputs

# Find and format files excluding specific patterns
find . -name "*.dart" \
    ! -path "*/bin/cache/*" \
    ! -name "*.chopper.dart" \
    ! -path "*/generated/*" \
    ! -path "*/gen/*" \
    ! -path "*/strings/*" \
    ! -name "*.g.dart" \
    ! -name "*.mocks.dart" \
    ! -name "*.freezed.dart" \
    -exec dart format --line-length 100 --indent 0 {} +

# Apply fixes - dart fix respects analysis_options.yaml exclusions
dart fix --apply

# Find and format files excluding specific patterns again (after fixes)
find . -name "*.dart" \
    ! -path "./bin/cache/*" \
    ! -name "*.chopper.dart" \
    ! -path "**/generated/**" \
    ! -path "**/gen/**" \
    ! -path "**/strings/**/*" \
    ! -name "*.g.dart" \
    ! -name "*.mocks.dart" \
    ! -name "*.freezed.dart" \
    -exec dart format --line-length 100 --indent 0 {} +

echo "Formatting completed for lib!"

# Change directory to test
cd ../test || exit

# Find and format files excluding specific patterns
find . -name "*.dart" \
    ! -path "*/bin/cache/*" \
    ! -name "*.chopper.dart" \
    ! -path "*/generated/*" \
    ! -path "*/gen/*" \
    ! -path "*/strings/*" \
    ! -name "*.g.dart" \
    ! -name "*.mocks.dart" \
    ! -name "*.freezed.dart" \
    -exec dart format --line-length 100 --indent 0 {} +

# Apply fixes - dart fix respects analysis_options.yaml exclusions
dart fix --apply

# Find and format files excluding specific patterns again (after fixes)
find . -name "*.dart" \
    ! -path "./bin/cache/*" \
    ! -name "*.chopper.dart" \
    ! -path "**/generated/**" \
    ! -path "**/gen/**" \
    ! -path "**/strings/**/*" \
    ! -name "*.g.dart" \
    ! -name "*.mocks.dart" \
    ! -name "*.freezed.dart" \
    -exec dart format --line-length 100 --indent 0 {} +

echo "Formatting completed for test!"
