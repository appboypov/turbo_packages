## MODIFIED Requirements

### Requirement: Pre-Publish Validation Workflow
Developers SHALL validate packages meet 160/160 pub points before publishing manually.

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

#### Scenario: Manual publishing with melos pub-publish
- **WHEN** running `melos pub-publish`
- **THEN** all packages SHALL pass pub-check validation
- **AND** a confirmation prompt SHALL appear before publishing
- **AND** `dart pub publish` SHALL be executed for each package
- **AND** published versions SHALL be immediately available on pub.dev
- **AND** publishing SHALL only occur when explicitly invoked by a developer (never automated)

## REMOVED Requirements

### Requirement: CI Automation for Publishing
**Reason**: All publishing is now manual to provide full developer control over release timing and prevent accidental publications.
**Migration**: Developers must run `melos pub-publish` locally when ready to publish packages.
