## ADDED Requirements

### Requirement: Template Configuration File
The system SHALL provide a `turbo_template_config.yaml` file at the template root containing configurable string values and sync metadata.

#### Scenario: Config file contains app identifiers
- **WHEN** developer reads the config file
- **THEN** it contains app name, package name, organization domain, and description with current template defaults

#### Scenario: Config file contains sync metadata
- **WHEN** developer reads the config file
- **THEN** it contains `template_path`, `last_commit_sync`, and `sync_upwards` fields

#### Scenario: Config file values match template defaults
- **WHEN** template is not yet initialized for a project
- **THEN** all values match the current hardcoded values in the template codebase

### Requirement: Project Initialization Script
The system SHALL provide an `init_project.dart` script that replaces all default config values with project-specific values across the entire template.

#### Scenario: Init script performs find-replace
- **WHEN** developer runs the init script
- **THEN** all occurrences of default values are replaced with the new values from config across flutter-app, firebase, and all other template files

#### Scenario: Init script is idempotent
- **WHEN** developer runs the init script multiple times
- **THEN** the result is the same as running it once

#### Scenario: Init script handles binary files
- **WHEN** init script encounters binary files (images, fonts, etc.)
- **THEN** it skips them without error

### Requirement: Downstream Sync Script
The system SHALL provide a `sync_from_template.dart` script that pulls changed files from the template to the project.

#### Scenario: Downstream sync uses git diff
- **WHEN** developer runs the downstream sync script
- **THEN** it identifies files changed in the template since `last_commit_sync` using git

#### Scenario: Downstream sync applies project config values
- **WHEN** files are copied from template to project
- **THEN** template default values are replaced with the project's config values

#### Scenario: Downstream sync leaves project-only files untouched
- **WHEN** project contains files not present in template
- **THEN** those files are not modified or deleted

#### Scenario: Downstream sync updates last_commit_sync
- **WHEN** sync completes successfully
- **THEN** `last_commit_sync` in the project's config is updated to the template's current HEAD

### Requirement: Upstream Sync Script
The system SHALL provide a `sync_to_template.dart` script that pushes allowed files from the project back to the template.

#### Scenario: Upstream sync respects sync_upwards whitelist
- **WHEN** developer runs the upstream sync script
- **THEN** only files listed in `sync_upwards` config array are considered for syncing

#### Scenario: Upstream sync reverts to template defaults
- **WHEN** files are copied from project to template
- **THEN** project-specific values are replaced with template default values

#### Scenario: Upstream sync uses git diff
- **WHEN** developer runs the upstream sync script
- **THEN** only files changed since `last_commit_sync` (from template perspective) are synced

#### Scenario: Upstream sync updates last_commit_sync
- **WHEN** sync completes successfully
- **THEN** `last_commit_sync` is updated in both project and template configs

### Requirement: Makefile Integration
The system SHALL provide Makefile targets for easy script invocation.

#### Scenario: Init target available
- **WHEN** developer runs `make init`
- **THEN** the init_project.dart script is executed

#### Scenario: Sync-from target available
- **WHEN** developer runs `make sync-from-template`
- **THEN** the sync_from_template.dart script is executed

#### Scenario: Sync-to target available
- **WHEN** developer runs `make sync-to-template`
- **THEN** the sync_to_template.dart script is executed

### Requirement: TViewBuilder in Shell
The ShellView SHALL use `TViewBuilder` from turbo_widgets instead of `ViewModelBuilder` from veto.

#### Scenario: Shell uses TViewBuilder
- **WHEN** ShellView is rendered
- **THEN** it uses TViewBuilder<ShellViewModel> for view model binding

#### Scenario: Shell behavior unchanged
- **WHEN** ShellView uses TViewBuilder
- **THEN** the auth/home view switching behavior remains identical
