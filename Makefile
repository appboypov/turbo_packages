.PHONY: help analyze format test build watch clean get pub-check pub-publish pub-publish-dry-run all

.DEFAULT_GOAL := help

# Package variable support (lowercase)
ifdef package
  MELOS_SCOPE = --scope=$(package)
else
  MELOS_SCOPE =
endif

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
	@melos analyze $(MELOS_SCOPE)

## format: Format all packages
format:
	@melos format $(MELOS_SCOPE)

## test: Run tests with coverage across all packages
test:
	@melos test $(MELOS_SCOPE) -- --coverage

## build: Run build_runner to generate code
build:
	@melos build_runner $(MELOS_SCOPE)

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
		echo "Error: clean requires package variable. Usage: make clean package=<package-name>"; \
		exit 1; \
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

## all: Run full CI pipeline (analyze, format, test)
all: analyze format test
