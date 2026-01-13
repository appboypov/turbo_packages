## ADDED Requirements

### Requirement: Pub.dev Publication Scripts
The monorepo SHALL provide Melos scripts for validating and publishing packages to pub.dev.

#### Scenario: Pub-check script validates 160/160 pub points
- **WHEN** running `melos pub-check`
- **THEN** all packages SHALL be validated against 160/160 pub points criteria
- **AND** the script SHALL run sequentially to identify all failing checks
- **AND** the script SHALL report which categories fail (conventions, docs, analysis, etc.)
- **AND** the script SHALL exit with non-zero code if any package fails

#### Scenario: Pub-publish script validates before publishing
- **WHEN** running `melos pub-publish --dry-run`
- **THEN** all packages SHALL pass pub-check validation
- **AND** the script SHALL run `dart pub publish --dry-run` for each package
- **AND** the script SHALL report which packages are ready to publish

#### Scenario: Pub-publish script publishes with confirmation
- **WHEN** running `melos pub-publish` (without --dry-run)
- **THEN** all packages SHALL pass pub-check validation
- **AND** the script SHALL prompt for confirmation before publishing
- **AND** the script SHALL run `dart pub publish` for each package
- **AND** the script SHALL report successful publishes with version numbers

### Requirement: Pub Points Validation with Pana
The monorepo SHALL use pana to validate 160/160 pub points locally.

#### Scenario: Pana validates Dart file conventions
- **WHEN** pana validates a package
- **THEN** it SHALL check for pubspec.yaml with required fields
- **AND** it SHALL check for LICENSE file (OSI-approved)
- **AND** it SHALL check for README.md
- **AND** it SHALL check for CHANGELOG.md in Keep a Changelog format
- **AND** it SHALL check that lib/<package_name>.dart exists

#### Scenario: Pana validates documentation
- **WHEN** pana validates a package
- **THEN** it SHALL check that at least 20% of public API members are documented
- **AND** it SHALL check that example/ or example.md exists

#### Scenario: Pana validates static analysis
- **WHEN** pana validates a package
- **THEN** it SHALL check that dart analyze passes with zero errors
- **AND** it SHALL check that dart analyze produces no warnings
- **AND** it SHALL check that dart format produces no changes
- **AND** it SHALL check that lints from package:lints are satisfied

#### Scenario: Pana validates platform support
- **WHEN** pana validates a package
- **THEN** it SHALL check for platform declarations (Android, iOS, Web, etc.)
- **AND** it SHALL check that pubspec.yaml declares supported platforms

#### Scenario: Pana validates dependency freshness
- **WHEN** pana validates a package
- **THEN** it SHALL check that dependencies are up-to-date with latest SDK
- **AND** it SHALL check that Flutter version constraints are compatible with latest stable

#### Scenario: Pana validates null safety
- **WHEN** pana validates a package
- **THEN** it SHALL confirm that sound null safety is enabled

### Requirement: Pre-Publish Checklist Documentation
The monorepo SHALL document the pub.dev publication process and best practices.

#### Scenario: Publishing guidelines in AGENTS.md
- **WHEN** reviewing workspace/AGENTS.md
- **THEN** it SHALL contain a "Publishing to pub.dev" section
- **AND** the section SHALL explain the 160/160 pub points categories
- **AND** the section SHALL provide step-by-step publishing workflow
- **AND** the section SHALL list common issues and how to fix them
- **AND** the section SHALL reference semantic versioning best practices
- **AND** the section SHALL document CHANGELOG.md format requirements

#### Scenario: Pre-publish checklist
- **WHEN** preparing to publish a package
- **THEN** developers SHALL verify:
  - Version is incremented according to semver
  - CHANGELOG.md updated with new version and changes
  - All tests pass (`melos test`)
  - Static analysis passes (`melos analyze`)
  - Code is formatted (`melos format`)
  - `melos pub-check` passes for the package
  - `melos pub-publish --dry-run` succeeds for the package

### Requirement: CI Validation of Publication Readiness
The monorepo SHALL automatically validate packages in CI before merging to main.

#### Scenario: GitHub Actions workflow validates pub-check on PR
- **WHEN** a PR is opened to main branch
- **THEN** GitHub Actions SHALL run `melos pub-check`
- **AND** the workflow SHALL fail the PR if any package doesn't meet 160/160 pub points
- **AND** the workflow SHALL report which categories fail for which packages
- **AND** the workflow SHALL not publish to pub.dev (dry-run only)

#### Scenario: CI validation prevents broken code from merging
- **WHEN** code is committed that breaks pub points
- **THEN** the PR SHALL be marked as failed
- **AND** the PR SHALL block merging until issues are fixed
- **AND** developers SHALL run `melos pub-check` locally before pushing

### Requirement: Development Convenience Commands (Makefile)
The monorepo SHALL provide a Makefile with convenient shorthand commands that delegate to Melos.

#### Scenario: Make targets for common development tasks
- **WHEN** running `make help`
- **THEN** all available targets SHALL be listed with descriptions
- **AND** developers can run `make analyze`, `make format`, `make test`, `make build`, `make pub-check`, `make pub-publish`
- **AND** each target SHALL delegate to the corresponding Melos command

#### Scenario: Make all target runs full CI pipeline
- **WHEN** running `make all`
- **THEN** it SHALL run analyze, format, and test in sequence
- **AND** it SHALL exit with non-zero code if any step fails
- **AND** this target is suitable for local CI validation before pushing

#### Scenario: Makefile provides help command
- **WHEN** viewing the Makefile
- **THEN** it SHALL contain documentation for all targets
- **AND** `make help` SHALL display commands sorted alphabetically with descriptions
- **AND** the Makefile SHALL be discoverable and referenced in README.md
