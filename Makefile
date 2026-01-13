.PHONY: help analyze format test build pub-check pub-publish pub-publish-dry-run all

.DEFAULT_GOAL := help

## help: Show this help message
help:
	@echo "Usage: make [target]"
	@echo ""
	@echo "Targets:"
	@grep -E '^## [a-zA-Z_-]+:.*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ": "}; {printf "  %-20s %s\n", $$1, $$2}'

## analyze: Run static analysis across all packages
analyze:
	@melos analyze

## format: Format all packages
format:
	@melos format

## test: Run tests across all packages
test:
	@melos test

## build: Run build_runner to generate code
build:
	@melos build_runner

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
