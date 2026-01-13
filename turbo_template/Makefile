.PHONY: help emulators deploy deploy-staging deploy-prod deploy-functions deploy-rules deploy-remoteconfig functions-install functions-build functions-watch

help: ## Show this help message
	@echo 'Usage: make [target]'
	@echo ''
	@echo 'Available targets:'
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "  %-20s %s\n", $$1, $$2}' $(MAKEFILE_LIST)

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
