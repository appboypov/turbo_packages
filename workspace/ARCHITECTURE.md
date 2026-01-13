# Architecture

## Overview
turbo_packages is a Melos-managed monorepo containing 7 Dart/Flutter packages that provide foundational utilities for building robust applications.

## Project Setup

### Prerequisites
- Dart SDK ^3.6.0
- Flutter SDK (for Flutter-dependent packages)
- Melos 7.x (installed via dev dependency)

### Installation
```bash
dart pub get
melos bootstrap
```

### Development
```bash
melos analyze    # Run static analysis
melos format     # Check formatting
melos test       # Run tests
melos build_runner  # Generate code
```

## Technology Stack

### Core Technologies
- Dart 3.6+
- Flutter (for UI packages)
- Melos 7.x (workspace management)
- Pub workspaces (dependency resolution)

### Key Dependencies
- cloud_firestore, firebase_auth (turbo_firestore_api)
- rxdart (turbo_firestore_api)
- provider (turbo_mvvm)
- get_it (turbolytics)
- json_serializable (turbo_promptable)

## Project Structure
```
turbo_packages/
├── pubspec.yaml              # Root workspace config
├── CHANGELOG.md              # Monorepo changelog
├── README.md                 # Monorepo documentation
├── turbo_response/           # Result type (Success/Fail)
├── turbo_serializable/       # Multi-format serialization
├── turbo_notifiers/          # Enhanced ValueNotifier
├── turbo_mvvm/               # MVVM state management
├── turbolytics/              # Logging & analytics
├── turbo_firestore_api/      # Firestore API wrapper
├── turbo_promptable/         # AI prompting framework
└── workspace/
    ├── AGENTS.md             # AI assistant instructions
    ├── ARCHITECTURE.md       # This file
    └── specs/                # Capability specifications
```

## Package Architecture

### Dependency Graph
```
turbo_response (foundation - no deps)
    └── turbo_serializable
            ├── turbo_promptable
            └── turbo_firestore_api

turbo_notifiers (standalone)
turbo_mvvm (standalone)
turbolytics (standalone)
```

### Package Categories

**Pure Dart Packages**
- turbo_response: Result type for operation outcomes
- turbo_serializable: JSON/YAML/Markdown/XML serialization
- turbo_promptable: AI agent prompt definitions

**Flutter Packages**
- turbo_notifiers: Enhanced ValueNotifier
- turbo_mvvm: ViewModel pattern implementation
- turbolytics: Logging and analytics
- turbo_firestore_api: Firestore abstraction

## Conventions

### Naming Conventions
- Package names: lowercase with underscores (turbo_*)
- Classes: PascalCase
- Files: snake_case

### Code Organization
- Each package follows standard Dart package structure
- Public API exported from lib/<package_name>.dart
- Internal implementation in lib/src/

### Error Handling
- Use TurboResponse (Success/Fail) for operation results
- Avoid throwing exceptions for expected failure cases

## API Patterns

### Internal Dependencies
- Packages depend on each other via workspace resolution
- No version constraints for internal dependencies
- Changes propagate immediately during development

### Publishing
- Each package maintains independent versioning
- Published to pub.dev with monorepo repository URLs
- Coordinated releases via Melos version command
