.PHONY: help init init-dry-run scripts-get sync-from-template sync-from-template-dry-run sync-to-template sync-to-template-dry-run emulators deploy deploy-staging deploy-prod deploy-functions deploy-rules deploy-remoteconfig functions-install functions-build functions-watch fix dart-fix

help: ## Show this help message
	@echo 'Usage: make [target]'
	@echo ''
	@echo 'Available targets:'
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "  %-20s %s\n", $$1, $$2}' $(MAKEFILE_LIST)

# Template Initialization
scripts-get: ## Install script dependencies
	cd scripts && dart pub get

init: scripts-get ## Initialize project from turbo_template_config.yaml
	dart run scripts/init_project.dart --yes

init-dry-run: scripts-get ## Preview initialization changes
	dart run scripts/init_project.dart --dry-run --verbose

sync-from-template: scripts-get ## Sync changes from template (downstream)
	dart run scripts/sync_from_template.dart

sync-from-template-dry-run: scripts-get ## Preview downstream sync changes
	dart run scripts/sync_from_template.dart --dry-run --verbose

sync-to-template: scripts-get ## Sync whitelisted changes to template (upstream)
	dart run scripts/sync_to_template.dart

sync-to-template-dry-run: scripts-get ## Preview upstream sync changes
	dart run scripts/sync_to_template.dart --dry-run --verbose

# Firebase Emulators
emulators: ## Start Firebase emulators
	cd flutter-app && ./scripts/run_emulators.sh

# Firebase Deployment
deploy: ## Deploy all Firebase resources to default project
	cd firebase && firebase deploy

deploy-staging: ## Deploy all Firebase resources to staging
	cd firebase && firebase deploy --project staging

deploy-prod: ## Deploy all Firebase resources to production
	cd firebase && firebase deploy --project default

deploy-functions: ## Deploy only Cloud Functions
	cd firebase && firebase deploy --only functions

deploy-rules: ## Deploy only Firestore and Storage rules
	cd firebase && firebase deploy --only firestore:rules,storage:rules

deploy-remoteconfig: ## Deploy Remote Config template
	cd firebase && firebase deploy --only remoteconfig

# Cloud Functions Development
functions-install: ## Install Cloud Functions dependencies
	cd firebase/functions && npm install

functions-build: ## Build Cloud Functions
	cd firebase/functions && npm run build

functions-watch: ## Watch and rebuild Cloud Functions
	cd firebase/functions && npm run build:watch

build-assets: ## Build Flutter assets
	@echo "🔧 Building Flutter assets..."
	cd flutter-app && flutter clean && flutter pub get && flutter gen-l10n && flutter pub run build_runner build --delete-conflicting-outputs

fix: ## Fix Flutter assets build issues
	@echo "🔧 Fixing Flutter assets build issues..."
	cd flutter-app && sh scripts/dart-fix.sh

dart-fix: ## Apply Dart fixes
	cd flutter-app && dart fix --apply
