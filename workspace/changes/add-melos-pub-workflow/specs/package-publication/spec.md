# Capability: Package Publication to pub.dev

## Overview

Defines the publication workflow, standards, and best practices for publishing turbo_packages to pub.dev. Ensures all packages meet pub.dev quality criteria (160/160 pub points) and follow semantic versioning and changelog conventions.

## ADDED Requirements

### Requirement: Package Publication Standards
All packages published to pub.dev SHALL meet the 160/160 pub points criteria.

#### Scenario: Dart file conventions compliance
- **WHEN** a package is prepared for publication
- **THEN** it SHALL have pubspec.yaml with all required fields (name, description, version, environment.sdk)
- **AND** it SHALL have a LICENSE file (OSI-approved, preferably BSD-3-Clause)
- **AND** it SHALL have README.md with package description and usage examples
- **AND** it SHALL have CHANGELOG.md in Keep a Changelog format
- **AND** it SHALL have lib/<package_name>.dart as the main library export
- **AND** implementation details SHALL be in lib/src/ and never directly imported from outside

#### Scenario: API documentation requirement
- **WHEN** a package is published
- **THEN** at least 20% of all public API members SHALL be documented with doc comments
- **AND** doc comments SHALL include clear descriptions, parameters, return values, and examples
- **AND** a working example SHALL exist in example/ directory

#### Scenario: Platform support declaration
- **WHEN** a package is published
- **THEN** supported platforms SHALL be declared in pubspec.yaml or implicitly via dependencies
- **AND** multi-platform packages SHALL use conditional imports where necessary
- **AND** platform-specific features SHALL be documented

#### Scenario: Static analysis and code quality
- **WHEN** a package is validated
- **THEN** `dart analyze` SHALL produce zero errors or warnings
- **AND** code SHALL be formatted with `dart format`
- **AND** lints from package:lints SHALL be satisfied
- **AND** all tests SHALL pass

#### Scenario: Dependency freshness
- **WHEN** a package is published
- **THEN** all dependencies SHALL be compatible with latest stable Dart SDK
- **AND** Flutter dependencies SHALL be compatible with latest stable Flutter SDK
- **AND** no outdated or abandoned dependencies SHALL be used

#### Scenario: Null safety requirement
- **WHEN** a package is published
- **THEN** sound null safety SHALL be enabled in pubspec.yaml
- **AND** all code SHALL use null-safety-aware patterns

### Requirement: Semantic Versioning
All package versions SHALL follow semantic versioning (MAJOR.MINOR.PATCH).

#### Scenario: Version format
- **WHEN** setting a version in pubspec.yaml
- **THEN** it SHALL follow the pattern MAJOR.MINOR.PATCH (e.g., 1.2.3)
- **AND** pre-release versions SHALL use format MAJOR.MINOR.PATCH-prerelease (e.g., 2.0.0-beta.1)

#### Scenario: Breaking changes trigger major version increment
- **WHEN** a breaking change is made to the public API
- **THEN** the MAJOR version SHALL be incremented
- **AND** CHANGELOG.md SHALL document the breaking change
- **AND** a migration guide SHALL be provided if the change is significant

#### Scenario: New features trigger minor version increment
- **WHEN** new backwards-compatible functionality is added
- **THEN** the MINOR version SHALL be incremented
- **AND** CHANGELOG.md SHALL list new features under "Added" section

#### Scenario: Bug fixes trigger patch version increment
- **WHEN** only bug fixes are included in a release
- **THEN** the PATCH version SHALL be incremented
- **AND** CHANGELOG.md SHALL list fixes under "Fixed" section

### Requirement: CHANGELOG Management
All packages SHALL maintain a CHANGELOG.md in Keep a Changelog format.

#### Scenario: CHANGELOG structure
- **WHEN** viewing a CHANGELOG.md
- **THEN** it SHALL have a top-level heading "# Changelog"
- **AND** each version SHALL have a level 2 heading (## MAJOR.MINOR.PATCH or ## vMAJOR.MINOR.PATCH)
- **AND** version headings SHALL be grouped by type: Added, Changed, Deprecated, Removed, Fixed, Security
- **AND** the format SHALL be compatible with pub.dev display

#### Scenario: CHANGELOG updated before release
- **WHEN** preparing to release a new version
- **THEN** CHANGELOG.md SHALL be updated with the new version
- **AND** all changes since the last version SHALL be documented
- **AND** the diff between last version and current code SHALL match the changelog

#### Scenario: Unreleased section for upcoming changes
- **WHEN** tracking changes between releases
- **THEN** CHANGELOG.md MAY include an "## Unreleased" section at the top
- **AND** changes SHALL be moved from Unreleased to a version heading when releasing

### Requirement: Pre-Publish Validation Workflow
Developers SHALL validate packages meet 160/160 pub points before publishing.

#### Scenario: Local validation with melos pub-check
- **WHEN** running `melos pub-check`
- **THEN** all packages SHALL be validated against 160/160 pub points criteria
- **AND** failing categories SHALL be clearly identified
- **AND** developers SHALL fix issues before proceeding

#### Scenario: Dry-run validation with melos pub-publish --dry-run
- **WHEN** running `melos pub-publish --dry-run`
- **THEN** all packages SHALL pass pub-check validation
- **AND** `dart pub publish --dry-run` SHALL be executed for each package
- **AND** no changes SHALL be committed to pub.dev

#### Scenario: Publishing with melos pub-publish
- **WHEN** running `melos pub-publish`
- **THEN** all packages SHALL pass pub-check validation
- **AND** a confirmation prompt SHALL appear before publishing
- **AND** `dart pub publish` SHALL be executed for each package
- **AND** published versions SHALL be immediately available on pub.dev

### Requirement: Version Constraint Management
Internal dependencies between monorepo packages SHALL use workspace resolution.

#### Scenario: Workspace resolution for internal dependencies
- **WHEN** a package depends on another package in the monorepo
- **THEN** the dependency SHALL declare `resolution: workspace` in pubspec.yaml
- **AND** the dependency SHALL NOT include a version constraint
- **AND** during local development, the workspace version is used
- **AND** after publishing, the dependency is resolved by pub.dev workspace

#### Scenario: External dependency version constraints
- **WHEN** declaring dependencies on external packages
- **THEN** version constraints SHALL use caret syntax (^1.2.3) to allow compatible updates
- **AND** exact versions SHALL be avoided to allow security patches
- **AND** dependency_overrides SHALL only be used for local development and NOT published

### Requirement: Published Package Metadata
Package metadata on pub.dev SHALL be complete and consistent.

#### Scenario: Pubspec metadata fields
- **WHEN** examining a package's pubspec.yaml
- **THEN** it SHALL include homepage, repository, issue_tracker, and documentation fields
- **AND** repository SHALL point to `https://github.com/appboypov/turbo_packages/tree/main/<package-name>`
- **AND** homepage SHALL point to `https://github.com/appboypov/turbo_packages`
- **AND** issue_tracker SHALL point to `https://github.com/appboypov/turbo_packages/issues`
- **AND** documentation SHALL point to pub.dev package documentation URL

#### Scenario: Package topics and keywords
- **WHEN** publishing a package
- **THEN** up to 5 relevant topics MAY be specified in pubspec.yaml
- **AND** topics SHALL help users discover the package on pub.dev

#### Scenario: README quality
- **WHEN** viewing a package's README.md on pub.dev
- **THEN** it SHALL contain a clear description of what the package does
- **AND** it SHALL include an example of basic usage
- **AND** it SHALL link to full documentation and issue tracker
