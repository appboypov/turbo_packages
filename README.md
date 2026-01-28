# Turbo Packages

A collection of Dart and Flutter packages for building robust applications.

## Packages

| Package | Description | pub.dev |
|---------|-------------|---------|
| [turbo_response](./turbo_response) | Type-safe response wrapper for success/failure states | [![pub](https://img.shields.io/pub/v/turbo_response.svg)](https://pub.dev/packages/turbo_response) |
| [turbo_serializable](./turbo_serializable) | Multi-format serialization (JSON, YAML, Markdown, XML) | [![pub](https://img.shields.io/pub/v/turbo_serializable.svg)](https://pub.dev/packages/turbo_serializable) |
| [turbo_notifiers](./turbo_notifiers) | Enhanced Flutter ValueNotifier | [![pub](https://img.shields.io/pub/v/turbo_notifiers.svg)](https://pub.dev/packages/turbo_notifiers) |
| [turbo_mvvm](./turbo_mvvm) | Lightweight MVVM state management | [![pub](https://img.shields.io/pub/v/turbo_mvvm.svg)](https://pub.dev/packages/turbo_mvvm) |
| [turbolytics](./turbolytics) | Logging, analytics, and crash reporting | [![pub](https://img.shields.io/pub/v/turbolytics.svg)](https://pub.dev/packages/turbolytics) |
| [turbo_firestore_api](./turbo_firestore_api) | Type-safe Firestore API wrapper | [![pub](https://img.shields.io/pub/v/turbo_firestore_api.svg)](https://pub.dev/packages/turbo_firestore_api) |
| [turbo_promptable](./turbo_promptable) | Object-Oriented Prompting for AI agents | [![pub](https://img.shields.io/pub/v/turbo_promptable.svg)](https://pub.dev/packages/turbo_promptable) |

## Development

This monorepo uses [Melos](https://melos.invertase.dev/) for workspace management.

### Setup

```bash
# Install dependencies
dart pub get

# Bootstrap all packages
melos bootstrap
```

### Common Commands

You can use either `make` or `melos` commands:

```bash
# Using Make (recommended for convenience)
make analyze      # Run analysis
make format       # Check formatting
make test         # Run tests
make build        # Run build_runner
make pub-check    # Validate pub.dev readiness
make help         # Show all available commands

# Using Melos directly
melos analyze
melos format
melos test
melos build_runner
melos pub-check
melos pub-publish-dry-run
```

### Publishing

Publishing guidelines:
- Run `melos pub-check` to validate 160/160 pub points before publishing
- Use `melos pub-publish` (or `make pub-publish`) to publish; see `tool/pub_publish.sh`
- Each package maintains independent versioning; use CHANGELOG.md and semantic versioning
- See Makefile and `tool/` for pub-check and pub-publish scripts

## License

See individual package directories for license information.
