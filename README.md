# Flutter Turbo Packages

A monorepo of foundational Flutter/Dart packages for building scalable applications.

## Packages

| Package | Description | Version |
|---------|-------------|---------|
| [turbo_response](./turbo_response) | Type-safe Success/Fail result wrapper | 1.0.0 |
| [turbo_notifiers](./turbo_notifiers) | Enhanced ValueNotifier for reactive state | 1.0.0 |
| [turbo_mvvm](./turbo_mvvm) | MVVM pattern with BaseViewModel and lifecycle management | 1.0.0 |
| [turbo_firestore_api](./turbo_firestore_api) | Type-safe Firestore wrapper with collection/document services | 1.0.0 |
| [turbo_forms](./turbo_forms) | Form configuration and validation system | 1.0.0 |
| [turbo_routing](./turbo_routing) | Type-safe routing abstraction over go_router | 1.0.0 |
| [turbo_widgets](./turbo_widgets) | Reusable UI components, extensions, and animations | 1.0.0 |
| [turbo_responsiveness](./turbo_responsiveness) | Responsive design utilities and adaptive widgets | 1.0.0 |
| [turbolytics](./turbolytics) | Unified logging, analytics, and crash reporting | 1.0.0 |

## Template

| Package | Description |
|---------|-------------|
| [turbo_flutter_template](./turbo_flutter_template) | Flutter project template using all turbo packages |

## Quick Start

### Prerequisites

- Dart SDK `>=3.5.0 <4.0.0`
- Flutter SDK `>=1.17.0`
- Melos `^7.0.0`

### Setup

```bash
# Install Melos
dart pub global activate melos

# Clone and bootstrap
git clone https://github.com/appboypov/turbo_packages.git
cd turbo_packages
melos bootstrap

# Configure git hooks
git config core.hooksPath .githooks
```

## Development

### Commands

| Command | Description |
|---------|-------------|
| `melos bootstrap` | Link local packages and resolve dependencies |
| `melos run test` | Run tests across all packages |
| `melos run analyze` | Analyze all packages |
| `melos run format` | Format all packages |
| `melos run format:check` | Check formatting (CI) |
| `melos run clean` | Clean build artifacts |
| `melos run get` | Get dependencies |

### Workflow

1. Make changes to any package
2. Changes are immediately available to dependent packages (no publishing needed)
3. Run validation before committing:
   ```bash
   melos run format:check && melos run analyze && melos run test
   ```

### Workspace Resolution

Packages use `resolution: workspace` in their `pubspec.yaml` files, enabling:
- Local development without publishing
- Immediate availability of changes across packages
- Faster iteration cycles

When published to pub.dev, version constraints are used instead.

## Git Strategy

This monorepo uses a hybrid git strategy:

- **Monorepo Repository**: Workspace configuration, CI/CD workflows, and scripts
- **Individual Package Repositories**: Each package maintains its own git repository for independent versioning

### Conventional Commits

All commits must follow [Conventional Commits](https://www.conventionalcommits.org/):

```
<type>(<scope>): <subject>
```

| Type | Description |
|------|-------------|
| `feat` | New feature (minor bump) |
| `fix` | Bug fix (patch bump) |
| `docs` | Documentation changes |
| `style` | Code style changes |
| `refactor` | Code refactoring |
| `test` | Test additions/changes |
| `chore` | Maintenance tasks |

**Breaking changes**: Add `BREAKING CHANGE:` in the commit body for major version bumps.

Git hooks validate commit messages automatically.

## Publishing

### Validation

All packages must achieve 160/160 pub.dev points before release:

```bash
cd <package_directory>
bash ../.github/scripts/check_pub_points.sh
```

### Release

```bash
# Preview release (dry-run)
melos publish

# Actual release
melos publish --no-dry-run
```

Melos automatically:
- Bumps versions based on conventional commits
- Generates changelogs
- Creates git tags (`package-name@version`)
- Publishes to pub.dev

## Documentation

- [ARCHITECTURE.md](./ARCHITECTURE.md) - Project architecture and patterns
- [RELEASE.md](./RELEASE.md) - Release preparation and publishing guide
- [CHANGELOG.md](./CHANGELOG.md) - Version history

## License

Each package has its own license. See individual package directories for details.
