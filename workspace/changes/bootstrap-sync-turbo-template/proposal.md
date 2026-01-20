# Change: Bootstrap and Sync Turbo Template

## Why

turbo_template needs proper configuration management and bidirectional sync capabilities to enable developers to bootstrap new projects efficiently and keep them synchronized with template updates.

## What Changes

- Migrate ShellView to use `TViewBuilder` from turbo_widgets instead of `ViewModelBuilder` from veto
- Extend existing `template.yaml` to `turbo_template_config.yaml` with sync metadata
- Create three Dart CLI scripts in `turbo_template/scripts/`:
  - `init_project.dart` - Initialize project with config values
  - `sync_from_template.dart` - Pull template changes to project (downstream)
  - `sync_to_template.dart` - Push project changes to template (upstream)
- Add Makefile targets for script invocation
- Validate all environments run without errors

## Impact

- Affected specs: turbo-template-sync (new capability)
- Affected code:
  - `turbo_template/flutter-app/lib/core/infrastructure/run-app/views/shell/shell_view.dart`
  - `turbo_template/turbo_template_config.yaml` (new)
  - `turbo_template/scripts/` (new directory with Dart scripts)
  - `turbo_template/Makefile`
