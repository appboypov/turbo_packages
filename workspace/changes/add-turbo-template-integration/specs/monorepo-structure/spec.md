## ADDED Requirements

### Requirement: Template Package Integration
The monorepo SHALL include turbo_template/flutter-app in the melos workspace for development workflows while excluding it from publishing operations.

#### Scenario: Template included in workspace
- **WHEN** examining the root pubspec.yaml workspace list
- **THEN** it SHALL include `turbo_template/flutter-app`
- **AND** the flutter-app SHALL have `resolution: workspace` in its pubspec.yaml

#### Scenario: Template excluded from publishing
- **WHEN** running `melos pub-check` or `melos pub-publish`
- **THEN** turbo_flutter_template SHALL be excluded via packageFilters.ignore

#### Scenario: Template participates in development workflows
- **WHEN** running `melos analyze`, `melos format`, or `melos test`
- **THEN** turbo_flutter_template SHALL be included

## MODIFIED Requirements

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

#### Scenario: Pub check script excludes non-publishable packages
- **WHEN** running `melos pub-check`
- **THEN** packages with packageFilters.ignore SHALL be excluded from validation

#### Scenario: Pub publish script excludes non-publishable packages
- **WHEN** running `melos pub-publish` or `melos pub-publish-dry-run`
- **THEN** packages with packageFilters.ignore SHALL be excluded from publishing
