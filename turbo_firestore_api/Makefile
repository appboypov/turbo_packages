.PHONY: help build clean test format analyze fix watch get barrels

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

test: ## Run tests with coverage
	@flutter test --coverage=coverage
	@dart run coverage:format_coverage --lcov --in=coverage --out=coverage/lcov.info --report-on=lib
	@echo "\n📊 Coverage Summary:"
	@cat coverage/lcov.info | awk '/^SF:/{gsub(/.*\/lib\//, "lib/", $$0); f=$$0}/^LF:/{lf=substr($$0,4)}/^LH:/{lh=substr($$0,4); if(f !~ /\.g\.dart$$/) {pct=(lf>0)?lh/lf*100:0; printf "  %-60s %5.1f%% (%d/%d)\n", f, pct, lh, lf; total_lh+=lh; total_lf+=lf}}END{pct=(total_lf>0)?total_lh/total_lf*100:0; printf "\n  %-60s %5.1f%% (%d/%d)\n", "TOTAL", pct, total_lh, total_lf}'
	@rm -rf coverage/

format: ## Format code
	dart format .

fix: ## Apply Dart fixes
	dart fix --apply

analyze: ## Run static analysis
	flutter analyze

get: ## Get dependencies
	flutter pub get

barrels: ## Generate barrel file exports for lib/turbo_firestore_api.dart
	@BARREL="lib/turbo_firestore_api.dart"; \
	PKG_NAME=$$(basename "$$BARREL" .dart); \
	{ \
		echo "library;"; \
		echo ""; \
		PREV_DIR=""; \
		find -L lib -name '*.dart' \
			-not -name "$$PKG_NAME.dart" \
			-not -name '*.g.dart' \
			-not -name '*.freezed.dart' \
			-not -path 'lib/turbo_firestore_api.dart' \
			| sort \
			| while read -r f; do \
				if grep -q '^part of ' "$$f"; then continue; fi; \
				REL=$${f#lib/}; \
				DIR=$$(dirname "$$REL" | cut -d/ -f1); \
				if [ "$$DIR" != "$$PREV_DIR" ]; then \
					if [ -n "$$PREV_DIR" ]; then echo ""; fi; \
					LABEL=$$(echo "$$DIR" | awk '{print toupper(substr($$0,1,1)) substr($$0,2)}'); \
					echo "/// $$LABEL"; \
					PREV_DIR="$$DIR"; \
				fi; \
				echo "export '$$REL';"; \
			done; \
	} > "$$BARREL"; \
	echo "Updated $$BARREL"
