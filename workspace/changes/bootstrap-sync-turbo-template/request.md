# Request: Bootstrap and Sync Turbo Template

## Source Input

```text
End goal: turbo_template ready for copy
Shall:
- use TView inside the shell
- confirm all environments run without errors
- have a turbo_template_config.yaml where with default string values used all throughout the app
- have a script that uses config file to 'change' all values to actual project values of project using the template
- have a script that compares the files in template (location in config) and then cp overrite all the files from template to current project with turbo_tempalte_config values of that projeect (only files since last_commit_sync in config)
- have a script that does the same but syncs it back to the project (only files since last_commit_sync in config) - template is leading in choosing which files to send - dont send files created unless they are explicitly shown in sync_upwards (array in config)
```

**Linear Issue:** TURBO-19

## Current Understanding

### What Exists Today
1. **Shell Implementation**: Uses `ViewModelBuilder<ShellViewModel>` from veto, NOT `TViewBuilder` from turbo_widgets
2. **Configuration**: Environment-based config via `--dart-define` flags (env=emulators/staging/prod), but no centralized YAML config for template string values
3. **Sync Scripts**: None exist - only emulator startup and Flutter run scripts exist
4. **Environments**: 4 environments configured (emulators, demo, staging, prod)

### Target Package
`turbo_template` (specifically `turbo_template/flutter-app/`)

### Proposed Components
1. **TViewBuilder Migration**: Replace `ViewModelBuilder` with `TViewBuilder` in shell
2. **turbo_template_config.yaml**: Central config file with:
   - Default template string values (app name, package name, etc.)
   - `template_path`: Location of source template
   - `last_commit_sync`: Timestamp/commit hash for sync operations
   - `sync_upwards`: Array of files allowed to sync from project → template
3. **Three Scripts**:
   - **init_project.sh**: Replace all default values with project-specific values from config
   - **sync_from_template.sh**: Pull changed files from template to project (downstream)
   - **sync_to_template.sh**: Push allowed files from project to template (upstream)

## Identified Ambiguities (All Resolved)

1. ~~TViewBuilder requirement scope - shell only or all views?~~ → Shell only
2. ~~What string values need to be configurable?~~ → All identifiers, URLs, Firebase IDs
3. ~~Script language preference?~~ → Dart CLI + Makefile
4. ~~How to detect changed files?~~ → Git commit hash
5. ~~Config transformations in-place or staging?~~ → In-place find-replace
6. ~~Extra files during downstream sync?~~ → Leave untouched

## Decisions

1. **TView Scope**: Shell only - only migrate ShellView to use TViewBuilder, leave other views as-is
2. **Config Values**: All identifiers (app name, package name, bundle ID, display name), URLs (privacy policy, terms of service, support), Firebase project IDs (configurable but defaults mimic current template state). Also copy relevant local files not committed to git (e.g., .env files, local configs).
3. **Script Language**: Dart CLI scripts with Makefile targets for easy invocation
4. **Sensitive Data Handling**: Keep it simple - avoid actual secrets (API keys, credentials) but file names, app names, package names, project IDs are fine to commit. No over-engineering.
5. **Change Detection**: Git commit hash - store last synced commit hash in config, use git diff to find changed files
6. **Extra Files in Project**: Leave untouched - only overwrite files that exist in template, project-specific files stay
7. **Value Replacement**: Hardcoded defaults - config lists old_value → new_value pairs, script does find-replace across all files. Template files remain readable and working as-is.
8. **Upstream Value Handling**: Read target template's config, replace project values back to template defaults before copying - keeps template in clean "template state"
9. **Script Location**: `turbo_template/scripts/` at template root - template-level scripts (init, sync) that can reference flutter-app scripts as needed. Template encompasses flutter-app + firebase + other folders.

## Final Intent

### Goal
Make turbo_template ready for copy with proper configuration management and bidirectional sync capabilities.

### Deliverables

1. **TViewBuilder in Shell**: Migrate `ShellView` to use `TViewBuilder` from turbo_widgets instead of `ViewModelBuilder` from veto.

2. **Environment Validation**: Confirm all environments (emulators, demo, staging, prod) run without errors.

3. **turbo_template_config.yaml**: Central config file at template root containing:
   - App identifiers (app name, package name, bundle ID, display name)
   - URLs (privacy policy, terms of service, support)
   - Firebase project IDs (with current values as defaults)
   - `template_path`: Path to source template location
   - `last_commit_sync`: Git commit hash of last sync
   - `sync_upwards`: Array of files allowed to sync project → template

4. **Dart CLI Scripts** in `turbo_template/scripts/`:
   - **init_project.dart**: Find-replace all default config values with project-specific values across entire template (flutter-app + firebase + all files)
   - **sync_from_template.dart**: Pull files changed since `last_commit_sync` from template to project, applying project's config values. Leave project-only files untouched.
   - **sync_to_template.dart**: Push files listed in `sync_upwards` that changed since `last_commit_sync` from project to template, reverting values to template defaults.

5. **Makefile Targets**: Easy invocation of the Dart scripts.

### Key Behaviors
- Change detection via git commit hash comparison
- Value replacement uses hardcoded defaults (old_value → new_value pairs in config)
- Upstream sync reverts project values to template defaults before copying
- Downstream sync leaves project-specific files untouched
- Scripts are idempotent and safe to run multiple times
- No actual secrets in config (API keys, credentials) - only identifiers and non-sensitive values
