---
status: done
skill-level: senior
parent-type: change
parent-id: bootstrap-sync-turbo-template
type: infrastructure
blocked-by:
  - 002-bootstrap-sync-turbo-template-create-config
  - 003-bootstrap-sync-turbo-template-init-script
  - 004-bootstrap-sync-turbo-template-downstream-sync
---

# 🏗️ Set up sync_to_template.dart script

## 🔗 Dependencies
> Which tasks need to be completed first (if any)?

- [ ] 002-bootstrap-sync-turbo-template-create-config
- [ ] 003-bootstrap-sync-turbo-template-init-script
- [ ] 004-bootstrap-sync-turbo-template-downstream-sync

## 🎯 Infrastructure Goal
> What infrastructure capability are we adding or improving?

Create a Dart CLI script that syncs allowed files from the project back to the template (upstream sync), reverting project-specific values to template defaults.

## 📍 Current State
> What is the current infrastructure setup?

No upstream sync mechanism exists. Developers manually copy files and revert values when contributing back to template.

## 🎯 Target State
> What should the infrastructure look like after this work?

`turbo_template/scripts/sync_to_template.dart` script that:
1. Reads project's `turbo_template_config.yaml` for `template_path`, `last_commit_sync`, and `sync_upwards`
2. Filters to only files listed in `sync_upwards` array
3. Uses git to find which of those files changed since `last_commit_sync`
4. Copies changed files from project to template
5. Reverts project values to template defaults during copy
6. Updates `last_commit_sync` in both project and template configs

## 🔧 Components
> What infrastructure components are involved?

### Script Features
- [ ] Read project config for template_path, last_commit_sync, sync_upwards
- [ ] Filter to only sync_upwards files
- [ ] Execute `git diff --name-only <last_commit_sync> HEAD` in project directory
- [ ] Intersect changed files with sync_upwards whitelist
- [ ] Copy files with value reversion (project values → template defaults)
- [ ] Update last_commit_sync in both configs
- [ ] Preview mode (--dry-run)

### Value Reversion
- [ ] Read project's config for project values
- [ ] Read template's config for default values
- [ ] Replace project values → template defaults during copy

### Whitelist Validation
- [ ] Validate sync_upwards paths exist in project
- [ ] Warn about paths in sync_upwards that don't exist
- [ ] Support glob patterns in sync_upwards (e.g., `lib/core/**/*.dart`)

### CLI Interface
- [ ] `dart run scripts/sync_to_template.dart` - run sync
- [ ] `dart run scripts/sync_to_template.dart --dry-run` - preview what would change
- [ ] `dart run scripts/sync_to_template.dart --force` - skip confirmation
- [ ] `dart run scripts/sync_to_template.dart --file <path>` - sync specific file (must be in whitelist)

## 🔐 Security Considerations
> What security measures are needed?

- [ ] Only sync files explicitly listed in sync_upwards
- [ ] Confirm before overwriting template files (unless --force)
- [ ] Show diff summary before proceeding

## 📋 Configuration Files
> What configuration files will be created/modified?

| File | Purpose |
|------|---------|
| `scripts/sync_to_template.dart` | Main upstream sync script |
| `Makefile` | Add `sync-to-template` target |

## ✅ Completion Criteria
> How do we verify the infrastructure is working?

- [ ] Script only syncs files in sync_upwards whitelist
- [ ] Files are copied with template defaults restored
- [ ] Non-whitelisted files are never synced
- [ ] last_commit_sync is updated in both project and template
- [ ] `make sync-to-template` target works

## 🚧 Constraints
> Any limitations or things to avoid?

- [ ] NEVER sync files not in sync_upwards array
- [ ] Do not create new files in template that don't exist in project
- [ ] Template is leading - only sync files that template expects

## 📝 Notes
> Additional context if needed

The sync_upwards array should default to common infrastructure files like:
- `flutter-app/pubspec.yaml`
- `flutter-app/lib/core/**/*.dart`
- `firebase/functions/**/*.ts`
- `Makefile`

Project-specific files like Firebase configs should NOT be in the default whitelist.
