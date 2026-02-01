.PHONY: help analyze fix format test build watch clean get pub-check pub-publish pub-publish-dry-run all

.DEFAULT_GOAL := help

## help: Show this help message
help:
	@echo "Usage: make [target] [package=<package-name>]"
	@echo ""
	@echo "Targets:"
	@grep -E '^## [a-zA-Z_-]+:.*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ": "}; {printf "  %-20s %s\n", $$1, $$2}'
	@echo ""
	@echo "Examples:"
	@echo "  make test                    # Run tests on all packages"
	@echo "  make test package=turbo_response  # Run tests on specific package"
	@echo "  make build package=turbo_mvvm    # Build specific package"

## analyze: Run static analysis across all packages
analyze:
	@if [ -n "$(package)" ]; then \
		cd $(package) && dart analyze --fatal-infos .; \
	else \
		melos analyze; \
	fi

## format: Format all packages
format:
	@if [ -n "$(package)" ]; then \
		cd $(package) && dart format .; \
	else \
		melos format; \
	fi

## fix: Apply Dart fixes across packages
fix:
	@if [ -n "$(package)" ]; then \
		cd $(package) && dart fix --apply; \
	else \
		melos fix; \
	fi

## test: Run tests with coverage across all packages
test:
	@if [ -n "$(package)" ]; then \
		cd $(package) && make test; \
	else \
		melos test; \
	fi

## build: Run build_runner to generate code
build:
	@if [ -n "$(package)" ]; then \
		cd $(package) && make build; \
	else \
		melos build_runner; \
	fi

## watch: Run build_runner in watch mode
watch:
	@if [ -n "$(package)" ]; then \
		cd $(package) && flutter pub run build_runner watch --delete-conflicting-outputs; \
	else \
		echo "Error: watch requires package variable. Usage: make watch package=<package-name>"; \
		exit 1; \
	fi

## clean: Clean build artifacts
clean:
	@if [ -n "$(package)" ]; then \
		cd $(package) && flutter clean && flutter pub get && dart run build_runner clean; \
	else \
		melos exec --fail-fast --concurrency=1 -- "\
			if [ -f pubspec.yaml ]; then \
				if grep -q '^flutter:' pubspec.yaml; then \
					flutter clean && flutter pub get; \
				else \
					dart pub get; \
				fi; \
				if grep -q '^[[:space:]]*build_runner:' pubspec.yaml; then \
					dart run build_runner clean; \
				fi; \
			fi"; \
	fi

## get: Get dependencies
get:
	@if [ -n "$(package)" ]; then \
		cd $(package) && flutter pub get; \
	else \
		melos bootstrap; \
	fi

## pub-check: Validate all packages meet 160/160 pub.dev points
pub-check:
	@melos pub-check

## pub-publish-dry-run: Validate packages for publishing without actually publishing
pub-publish-dry-run:
	@melos pub-publish-dry-run

## pub-publish: Publish packages to pub.dev (requires confirmation)
pub-publish:
	@melos pub-publish

## all: Run full CI pipeline (format, analyze, test)
all: clean get fix format analyze test
