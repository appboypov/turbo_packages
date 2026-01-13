# Capability: Monorepo Structure

## Overview
Defines the structure and configuration of the turbo_packages Melos monorepo.

## Requirements

### Requirement: Melos Workspace Configuration
The monorepo SHALL use Melos 7.x with pub workspaces for package management.

#### Scenario: Root pubspec.yaml defines workspace
- **WHEN** examining the root pubspec.yaml
- **THEN** it SHALL contain a `workspace:` key listing all packages
- **AND** it SHALL have `publish_to: none`
- **AND** it SHALL include melos as a dev dependency

#### Scenario: Melos configuration embedded in pubspec
- **WHEN** examining the root pubspec.yaml
- **THEN** it SHALL contain a `melos:` configuration block
- **AND** the block SHALL specify the repository URL
- **AND** the block SHALL define standard scripts (analyze, format, test, build_runner)

### Requirement: Package Workspace Resolution
Each package SHALL declare workspace resolution for dependency management.

#### Scenario: Package pubspec includes resolution directive
- **WHEN** examining any package's pubspec.yaml
- **THEN** it SHALL contain `resolution: workspace`

#### Scenario: Internal dependencies use workspace resolution
- **WHEN** a package depends on another package in the monorepo
- **THEN** it SHALL omit the version constraint
- **AND** the dependency SHALL be resolved via the workspace

### Requirement: SDK Version Alignment
All packages SHALL use compatible SDK constraints for pub workspace support.

#### Scenario: Minimum SDK version
- **WHEN** examining any pubspec.yaml in the monorepo
- **THEN** the SDK constraint SHALL be ^3.6.0 or higher

### Requirement: Repository URL Convention
All packages SHALL use consistent repository URLs pointing to the monorepo.

#### Scenario: Package repository URL format
- **WHEN** examining a package's pubspec.yaml
- **THEN** the repository URL SHALL follow the pattern `https://github.com/appboypov/turbo_packages/tree/main/<package-name>`
- **AND** the homepage SHALL be `https://github.com/appboypov/turbo_packages`
- **AND** the issue_tracker SHALL be `https://github.com/appboypov/turbo_packages/issues`

### Requirement: Flat Package Structure
Packages SHALL reside at the repository root level.

#### Scenario: Package directory location
- **WHEN** listing the repository root
- **THEN** each package directory SHALL exist directly under the root
- **AND** packages SHALL NOT be nested in a subdirectory

### Requirement: Melos Scripts
The monorepo SHALL provide standard Melos scripts for common operations.

#### Scenario: Analyze script
- **WHEN** running `melos analyze`
- **THEN** dart analyze SHALL run on all packages with --fatal-infos

#### Scenario: Format script
- **WHEN** running `melos format`
- **THEN** dart format SHALL check all packages

#### Scenario: Test script
- **WHEN** running `melos test`
- **THEN** flutter test SHALL run on packages containing a test directory

#### Scenario: Build runner script
- **WHEN** running `melos build_runner`
- **THEN** build_runner SHALL execute on packages that depend on it

## Packages

| Package | Description |
|---------|-------------|
| turbo_response | Type-safe response wrapper for success/failure states |
| turbo_serializable | Multi-format serialization (JSON, YAML, Markdown, XML) |
| turbo_notifiers | Enhanced Flutter ValueNotifier |
| turbo_mvvm | Lightweight MVVM state management |
| turbolytics | Logging, analytics, and crash reporting |
| turbo_firestore_api | Type-safe Firestore API wrapper |
| turbo_promptable | Object-Oriented Prompting for AI agents |

## Internal Dependency Graph

```
turbo_response (foundation)
    └── turbo_serializable
            ├── turbo_promptable
            └── turbo_firestore_api
```
