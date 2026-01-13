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

### Requirement: Template Sync Hook
The monorepo SHALL provide a post-commit hook that syncs turbo_template to an external directory when template files change.

#### Scenario: Sync triggers on template changes
- **WHEN** a commit modifies files in turbo_template/
- **THEN** the post-commit hook SHALL sync the template to the configured target

#### Scenario: Sync skips when template unchanged
- **WHEN** a commit does not modify files in turbo_template/
- **THEN** the post-commit hook SHALL skip the sync operation

#### Scenario: Sync excludes build artifacts
- **WHEN** the sync operation runs
- **THEN** it SHALL exclude build/, .dart_tool/, node_modules/, Pods/, .gradle/, *.lock, .firebase/, coverage/, .idea/, .vscode/, .DS_Store, and .git/

#### Scenario: Sync target is configurable
- **WHEN** SYNC_TEMPLATE_TARGET environment variable is set
- **THEN** the sync SHALL use that path as the target
- **OTHERWISE** it SHALL default to ~/Repos/turbo-template

### Requirement: Template Sync Makefile Targets
The monorepo SHALL provide Makefile targets for template sync operations.

#### Scenario: Manual sync target
- **WHEN** running `make sync-template`
- **THEN** the template SHALL sync to the configured target directory

#### Scenario: Hook setup target
- **WHEN** running `make setup-hooks`
- **THEN** the post-commit hook SHALL be installed to .git/hooks/

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
