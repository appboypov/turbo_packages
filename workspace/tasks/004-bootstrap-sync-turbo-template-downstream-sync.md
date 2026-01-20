---
status: done
skill-level: senior
parent-type: change
parent-id: bootstrap-sync-turbo-template
type: infrastructure
blocked-by:
  - 002-bootstrap-sync-turbo-template-create-config
  - 003-bootstrap-sync-turbo-template-init-script
---

# 🏗️ Set up sync_from_template.dart script

## 🔗 Dependencies
> Which tasks need to be completed first (if any)?

- [ ] 002-bootstrap-sync-turbo-template-create-config
- [ ] 003-bootstrap-sync-turbo-template-init-script

## 🎯 Infrastructure Goal
> What infrastructure capability are we adding or improving?

Create a Dart CLI script that syncs changed files from the template to the project (downstream sync), applying project-specific config values to the synced files.

## 📍 Current State
> What is the current infrastructure setup?

No downstream sync mechanism exists. Developers manually copy files when template updates.

## 🎯 Target State
> What should the infrastructure look like after this work?

`turbo_template/scripts/sync_from_template.dart` script that:
1. Reads project's `turbo_template_config.yaml` for `template_path` and `last_commit_sync`
2. Uses git to find files changed in template since `last_commit_sync`
3. Copies changed files from template to project
4. Applies project's config values (replaces template defaults with project values)
5. Updates `last_commit_sync` to template's current HEAD
6. Leaves project-only files untouched

## 🔧 Components
> What infrastructure components are involved?

### Script Features
- [ ] Read project config for template_path and last_commit_sync
- [ ] Execute `git diff --name-only <last_commit_sync> HEAD` in template directory
- [ ] Filter changed files (respect .gitignore patterns)
- [ ] Copy files with value replacement
- [ ] Update last_commit_sync after successful sync
- [ ] Preview mode (--dry-run)

### Git Integration
- [ ] Validate template_path is a git repository
- [ ] Handle case where last_commit_sync is empty (first sync - copy all files)
- [ ] Handle case where last_commit_sync commit doesn't exist (fallback to full sync)
- [ ] Get current HEAD commit hash from template

### Value Replacement
- [ ] Read template's config for default values
- [ ] Read project's config for project values
- [ ] Replace template defaults → project values during copy

### CLI Interface
- [ ] `dart run scripts/sync_from_template.dart` - run sync
- [ ] `dart run scripts/sync_from_template.dart --dry-run` - preview what would change
- [ ] `dart run scripts/sync_from_template.dart --force` - skip confirmation

## 🔐 Security Considerations
> What security measures are needed?

- [ ] Validate template_path exists and is accessible
- [ ] Confirm before overwriting files (unless --force)
- [ ] Show diff summary before proceeding

## 📋 Configuration Files
> What configuration files will be created/modified?

| File | Purpose |
|------|---------|
| `scripts/sync_from_template.dart` | Main downstream sync script |
| `scripts/lib/git_utils.dart` | Git command execution utilities |
| `scripts/lib/sync_utils.dart` | Shared sync logic |
| `Makefile` | Add `sync-from-template` target |

## ✅ Completion Criteria
> How do we verify the infrastructure is working?

- [ ] Script correctly identifies changed files via git
- [ ] Files are copied with project values applied
- [ ] Project-only files are not modified
- [ ] last_commit_sync is updated after sync
- [ ] `make sync-from-template` target works

## 🚧 Constraints
> Any limitations or things to avoid?

- [ ] Do not delete project files not in template
- [ ] Do not modify template directory
- [ ] Respect .gitignore in both template and project

## 📝 Notes
> Additional context if needed

The script reuses the file_processor.dart and config_reader.dart from the init script. Git operations use `Process.run` from dart:io.
