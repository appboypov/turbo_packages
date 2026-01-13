.PHONY: help init init-dry-run emulators flutter-emulators staging prod demo build watch clean test format analyze get icons splash setup-ios setup-android setup-icons setup-splash setup-firebase setup-env setup-all

help: ## Show this help message
	@echo 'Usage: make [target]'
	@echo ''
	@echo 'Available targets:'
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "  %-20s %s\n", $$1, $$2}' $(MAKEFILE_LIST)

# Template Setup
init: ## Initialize template from config file
	cd tool && dart run tool:init_template

init-dry-run: ## Preview template initialization
	cd tool && dart run tool:init_template --dry-run

# Guided Setup Commands (copies agent prompt to clipboard)
setup-all: ## Show all setup tasks with status
	@echo '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━'
	@echo '                    PROJECT SETUP GUIDE'
	@echo '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━'
	@echo ''
	@echo 'Run these commands to configure each aspect of your project.'
	@echo 'Each command shows instructions and copies an agent prompt.'
	@echo ''
	@echo '  make setup-firebase   Configure Firebase project'
	@echo '  make setup-ios        Configure iOS signing & capabilities'
	@echo '  make setup-android    Configure Android signing'
	@echo '  make setup-icons      Configure app launcher icons'
	@echo '  make setup-splash     Configure splash screens'
	@echo '  make setup-env        Configure environment variables'
	@echo ''
	@echo '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━'

setup-firebase: ## Setup Firebase (copies agent prompt)
	@echo '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━'
	@echo '                    FIREBASE SETUP'
	@echo '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━'
	@echo ''
	@echo 'Prerequisites:'
	@echo '  1. Firebase CLI installed (npm install -g firebase-tools)'
	@echo '  2. FlutterFire CLI installed (dart pub global activate flutterfire_cli)'
	@echo '  3. Firebase projects created (prod + staging)'
	@echo ''
	@echo 'Manual steps:'
	@echo '  1. Run: firebase login'
	@echo '  2. Run: cd flutter-app && flutterfire configure'
	@echo '  3. Update firebase/.firebaserc with your project IDs'
	@echo ''
	@echo '✓ Agent prompt copied to clipboard'
	@echo '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━'
	@printf '%s' "Configure Firebase for this Flutter project. Steps: 1) Check firebase/.firebaserc for project aliases (default=prod, staging). 2) Check if lib/firebase_options.dart exists and review current Firebase project ID. 3) If the project ID is 'a-pew-pew-app' (template default), inform me I need to run 'firebase login' then 'flutterfire configure' to set up my own Firebase project. 4) Review firebase/firebase.json for functions, firestore, storage, and remote config setup. 5) Check firebase/functions/ for Cloud Functions. 6) Check if GoogleService-Info.plist (iOS) and google-services.json (Android) exist in the Flutter app. 7) List Firebase services configured based on pubspec.yaml dependencies." | pbcopy

setup-ios: ## Setup iOS signing (copies agent prompt)
	@echo '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━'
	@echo '                    iOS SETUP'
	@echo '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━'
	@echo ''
	@echo 'Prerequisites:'
	@echo '  1. Apple Developer account'
	@echo '  2. Xcode installed with command line tools'
	@echo ''
	@echo 'Manual steps required in Xcode:'
	@echo '  1. Open ios/Runner.xcworkspace in Xcode'
	@echo '  2. Select Runner target → Signing & Capabilities'
	@echo '  3. Set your Team (Apple Developer account)'
	@echo '  4. Update Bundle Identifier if needed'
	@echo '  5. Configure capabilities (Push Notifications, Sign in with Apple, etc.)'
	@echo ''
	@echo '✓ Agent prompt copied to clipboard'
	@echo '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━'
	@printf '%s' "Review and help configure iOS settings for this Flutter project. Steps: 1) Read ios/Runner.xcodeproj/project.pbxproj and find DEVELOPMENT_TEAM and PRODUCT_BUNDLE_IDENTIFIER values. 2) Read ios/Runner/Info.plist for app configuration (display name, permissions, URL schemes). 3) Check ios/Runner/Runner.entitlements and ios/Runner/RunnerRelease.entitlements for capabilities. 4) Review ios/Runner/Configs/AppInfo.xcconfig for build settings. 5) List what needs manual configuration in Xcode (Team ID, capabilities). 6) If I provide my Team ID, update DEVELOPMENT_TEAM in project.pbxproj. 7) Check for any iOS-specific Firebase configuration in ios/Runner/GoogleService-Info.plist." | pbcopy

setup-android: ## Setup Android signing (copies agent prompt)
	@echo '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━'
	@echo '                    ANDROID SETUP'
	@echo '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━'
	@echo ''
	@echo 'For release builds, you need a signing key:'
	@echo ''
	@echo '1. Generate keystore (one-time):'
	@echo '   keytool -genkey -v -keystore ~/my-release-key.jks \\'
	@echo '     -keyalg RSA -keysize 2048 -validity 10000 -alias my-key'
	@echo ''
	@echo '2. Create android/key.properties (gitignored):'
	@echo '   storePassword=<password>'
	@echo '   keyPassword=<password>'
	@echo '   keyAlias=my-key'
	@echo '   storeFile=/path/to/my-release-key.jks'
	@echo ''
	@echo '✓ Agent prompt copied to clipboard'
	@echo '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━'
	@printf '%s' "Review and help configure Android settings for this Flutter project. Steps: 1) Read android/app/build.gradle.kts for applicationId, minSdk, targetSdk, and signing config. 2) Check if android/key.properties exists (it should be gitignored). 3) Read android/app/src/main/AndroidManifest.xml for permissions, app label, and intent filters. 4) Check android/app/src/main/res/ for launcher icons and splash resources. 5) Review android/app/proguard-rules.pro if it exists for release obfuscation rules. 6) If signing is not configured, create the signing configuration in build.gradle.kts that reads from key.properties. 7) List any Android permissions currently requested and suggest if more are needed based on Firebase services used." | pbcopy

setup-icons: ## Setup app icons (copies agent prompt)
	@echo '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━'
	@echo '                    APP ICONS SETUP'
	@echo '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━'
	@echo ''
	@echo 'This project uses flutter_launcher_icons for icon generation.'
	@echo ''
	@echo 'Steps:'
	@echo '  1. Place your icon at assets/icon/icon.png (1024x1024 recommended)'
	@echo '  2. Optionally add assets/icon/icon-adaptive-foreground.png for Android'
	@echo '  3. Configure flutter_launcher_icons.yaml'
	@echo '  4. Run: make icons'
	@echo ''
	@echo '✓ Agent prompt copied to clipboard'
	@echo '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━'
	@printf '%s' "Configure app launcher icons for this Flutter project. Steps: 1) Check if flutter_launcher_icons is in dev_dependencies in pubspec.yaml - if not, add it. 2) Check if flutter_launcher_icons.yaml exists at project root - if not, create it. 3) Look for existing icon files in assets/icon/ or similar directories. 4) Create or update flutter_launcher_icons.yaml with configuration for: android (adaptive icons with foreground/background), ios, web, macos, windows. 5) The config should reference icon files and set appropriate background colors. 6) After configuration, remind me to run 'make icons' to generate all platform icons. 7) If no source icon exists, tell me to create a 1024x1024 PNG icon first." | pbcopy

setup-splash: ## Setup splash screens (copies agent prompt)
	@echo '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━'
	@echo '                    SPLASH SCREEN SETUP'
	@echo '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━'
	@echo ''
	@echo 'This project uses flutter_native_splash for splash screens.'
	@echo ''
	@echo 'Steps:'
	@echo '  1. Place your splash image at assets/splash/splash.png'
	@echo '  2. Configure flutter_native_splash.yaml'
	@echo '  3. Run: make splash'
	@echo ''
	@echo '✓ Agent prompt copied to clipboard'
	@echo '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━'
	@printf '%s' "Configure native splash screens for this Flutter project. Steps: 1) Check if flutter_native_splash is in dev_dependencies in pubspec.yaml - if not, add it. 2) Check if flutter_native_splash.yaml exists at project root - if not, create it. 3) Look for existing splash assets in assets/splash/ or similar. 4) Create or update flutter_native_splash.yaml with: color or background_image, image (centered logo), android_12 settings for Android 12+ splash, ios, web configurations. 5) Configure dark mode splash if the app supports dark mode. 6) After configuration, remind me to run 'make splash' to generate native splash screens. 7) If no source splash image exists, suggest creating one or using the app icon." | pbcopy

setup-env: ## Setup environment config (copies agent prompt)
	@echo '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━'
	@echo '                    ENVIRONMENT SETUP'
	@echo '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━'
	@echo ''
	@echo 'This project supports multiple environments:'
	@echo '  • demo     - Demo mode with mock data'
	@echo '  • staging  - Staging environment'
	@echo '  • prod     - Production environment'
	@echo ''
	@echo 'Run with: flutter run --dart-define=env=<environment>'
	@echo 'Or use:   make demo | make staging | make prod'
	@echo ''
	@echo '✓ Agent prompt copied to clipboard'
	@echo '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━'
	@printf '%s' "Review and help configure environment settings for this Flutter project. Steps: 1) Read lib/environment/ directory structure to understand current environment setup. 2) Check lib/environment/enums/environment.dart for available environments. 3) Review lib/environment/config/ for environment-specific configurations. 4) Check lib/environment/globals/ for global environment access patterns. 5) Look at how --dart-define=env is used to switch environments. 6) Review emulator_config.dart for local development with Firebase emulators. 7) Suggest any improvements to the environment configuration pattern. 8) If I want to add a new environment or modify existing ones, help configure it properly." | pbcopy

# Development
emulators: ## Start Firebase emulators (uses root firebase/)
	./scripts/run_emulators.sh

flutter-emulators: ## Run Flutter connected to emulators
	./scripts/run_flutter.sh

staging: ## Run Flutter with staging environment
	flutter run --dart-define=env=staging

prod: ## Run Flutter with production environment
	flutter run --dart-define=env=prod

demo: ## Run Flutter in demo mode
	flutter run --dart-define=env=demo

# Code Generation
build: ## Run build_runner to generate code
	flutter pub run build_runner build --delete-conflicting-outputs

watch: ## Run build_runner in watch mode
	flutter pub run build_runner watch --delete-conflicting-outputs

icons: ## Generate app icons (requires flutter_launcher_icons)
	flutter pub run flutter_launcher_icons

splash: ## Generate splash screens (requires flutter_native_splash)
	flutter pub run flutter_native_splash:create

# Quality
test: ## Run tests
	flutter test

format: ## Format code
	dart format .

analyze: ## Run static analysis
	flutter analyze

# Maintenance
clean: ## Clean build artifacts
	flutter clean
	rm -f .emulator_ports.json

get: ## Get dependencies
	flutter pub get
