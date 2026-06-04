# Turbo Packages

[![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](#license)
[![Dart SDK](https://img.shields.io/badge/Dart-%5E3.10-0175C2.svg)](https://dart.dev)
[![Melos](https://img.shields.io/badge/maintained%20with-melos-f700ff.svg)](https://melos.invertase.dev/)

A collection of focused Dart and Flutter packages for building robust applications — type-safe responses, MVVM state management, Firestore access, serialization, forms, observability, and AI prompting. Each package is published independently to pub.dev and validated at a 160/160 pana score.

## Table of Contents

- [Packages](#packages)
- [Getting Started](#getting-started)
- [Development](#development)
- [Publishing](#publishing)
- [Contributing](#contributing)
- [License](#license)

## Packages

| Package | Platform | Description | pub.dev |
|---------|----------|-------------|---------|
| [turbo_response](./turbo_response) | Dart | Type-safe response wrapper for success/failure states with pattern matching and utility methods | [![pub](https://img.shields.io/pub/v/turbo_response.svg)](https://pub.dev/packages/turbo_response) |
| [turbo_mvvm](./turbo_mvvm) | Flutter | Lightweight MVVM state management inspired by the Stacked package | [![pub](https://img.shields.io/pub/v/turbo_mvvm.svg)](https://pub.dev/packages/turbo_mvvm) |
| [turbo_notifiers](./turbo_notifiers) | Flutter | Enhanced behaviour over Flutter's `ValueNotifier` | [![pub](https://img.shields.io/pub/v/turbo_notifiers.svg)](https://pub.dev/packages/turbo_notifiers) |
| [turbo_forms](./turbo_forms) | Flutter | Type-safe form field configuration and validation for Flutter with ShadCN UI integration | [![pub](https://img.shields.io/pub/v/turbo_forms.svg)](https://pub.dev/packages/turbo_forms) |
| [turbo_firestore_api](./turbo_firestore_api) | Flutter | Clean, efficient, type-safe approach to dealing with Firestore data | [![pub](https://img.shields.io/pub/v/turbo_firestore_api.svg)](https://pub.dev/packages/turbo_firestore_api) |
| [turbo_serializable](./turbo_serializable) | Dart | Serialization abstraction with multi-format support (JSON, YAML, Markdown, XML) | [![pub](https://img.shields.io/pub/v/turbo_serializable.svg)](https://pub.dev/packages/turbo_serializable) |
| [turbolytics](./turbolytics) | Flutter | User-friendly way to implement logs, analytics, and crash reports | [![pub](https://img.shields.io/pub/v/turbolytics.svg)](https://pub.dev/packages/turbolytics) |
| [turbo_promptable](./turbo_promptable) | Dart | Object-Oriented Prompting framework for AI agent prompts, roles, workflows, and tools as type-safe Dart objects | [![pub](https://img.shields.io/pub/v/turbo_promptable.svg)](https://pub.dev/packages/turbo_promptable) |

## Getting Started

Each package is standalone — add only the ones you need. Install from pub.dev:

```bash
dart pub add turbo_response
# or for a Flutter package
flutter pub add turbo_forms
```

Then import and use it:

```dart
import 'package:turbo_response/turbo_response.dart';
```

See each package's own `README.md` and `example/` directory for usage details and API documentation.

## Development

This is a [Melos](https://melos.invertase.dev/)-managed monorepo. Requires the Dart SDK `^3.10`.

### Setup

```bash
# Install dependencies and bootstrap the workspace
dart pub get
melos bootstrap
```

### Common Commands

Use either `make` (convenience wrappers) or `melos` directly:

```bash
# Using Make
make analyze      # Run static analysis
make format       # Format code
make test         # Run tests with coverage
make build        # Run build_runner
make pub-check    # Validate pub.dev readiness (160/160 pana)
make help         # Show all available commands

# Using Melos
melos analyze
melos format
melos test
melos build_runner
melos pub-check
melos pub-publish-dry-run
```

## Publishing

- Run `melos pub-check` to validate a 160/160 pana score before publishing.
- Use `melos pub-publish` (or `make pub-publish`) to publish; see `tool/pub_publish.sh`.
- Each package maintains independent versioning following [semantic versioning](https://semver.org/) — update its `CHANGELOG.md` per release.
- Validation and publish scripts live in `tool/`.

## Contributing

Contributions are welcome. See [CONTRIBUTING.md](./CONTRIBUTING.md) for the development workflow, branch and commit conventions, and the checks a change must pass before merge.

## License

Distributed under the MIT License. See the root [`LICENSE`](./LICENSE) file, or the `LICENSE` file in each package directory, for details.
