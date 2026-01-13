.PHONY: help build clean test format analyze

help: ## Show this help message
	@echo 'Usage: make [target]'
	@echo ''
	@echo 'Available targets:'
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "  %-15s %s\n", $$1, $$2}' $(MAKEFILE_LIST)

build: ## Run build_runner to generate code
	flutter pub run build_runner build --delete-conflicting-outputs

watch: ## Run build_runner in watch mode
	flutter pub run build_runner watch --delete-conflicting-outputs

clean: ## Clean build artifacts
	flutter clean
	flutter pub get
	dart run build_runner clean

test: ## Run tests
	flutter test

format: ## Format code
	dart format .

analyze: ## Run static analysis
	flutter analyze

get: ## Get dependencies
	flutter pub get
