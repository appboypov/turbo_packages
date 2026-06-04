# Contributing to Turbo Packages

Thanks for your interest in contributing. This is a [Melos](https://melos.invertase.dev/)-managed monorepo containing multiple independently published Dart and Flutter packages.

## Prerequisites

- Dart SDK `^3.10`
- [Melos](https://melos.invertase.dev/) (declared as a dev dependency — no global install required)

## Setup

```bash
dart pub get
melos bootstrap
```

## Development Workflow

1. Create a branch off `main` for your change.
2. Make your changes within the relevant package directory.
3. Run the checks below until they all pass.
4. Update the affected package's `CHANGELOG.md` and bump its version following [semantic versioning](https://semver.org/).
5. Open a pull request against `main`.

## Checks

Run from the repository root. Use either `make` or `melos`:

```bash
make analyze      # Static analysis (dart analyze --fatal-infos)
make format       # Format code
make test         # Run tests with coverage
make build        # Run build_runner where applicable
make pub-check    # Validate pub.dev readiness (160/160 pana)
```

A change must satisfy:

- `make analyze` reports zero issues (infos are treated as fatal).
- Code is formatted (`make format`).
- `make test` passes for every affected package.
- `make pub-check` reports a 160/160 pana score for any package you intend to publish.

## Commit Conventions

This repository uses [Conventional Commits](https://www.conventionalcommits.org/). Scope the commit to the affected package where relevant:

```
feat(turbo_firestore_api): add listByIds lookup
fix(turbo_response): make result nullable instead of throwing on Fail
```

## Versioning and Publishing

Each package is versioned and published independently. See the [Publishing](./README.md#publishing) section of the README for the release process. Maintainers handle pub.dev publishing.

## License

By contributing, you agree that your contributions are licensed under the MIT License.
