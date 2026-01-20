# Bootstrap and Sync Turbo Template Progress

## Workflow Instructions

**IMPORTANT**: Read this entire file after each conversation compact to restore context.

### After Compact Checklist
- [ ] Read this file fully
- [ ] Check current status in Status Overview
- [ ] Run `splx get task` to get next task
- [ ] Resume from where left off

---

## Context

**Goal**: Make turbo_template ready for copy with TViewBuilder, configuration management, and bidirectional sync scripts.

**Linear Issue**: TURBO-19

**Source Files**:
- `workspace/changes/bootstrap-sync-turbo-template/proposal.md`
- `workspace/changes/bootstrap-sync-turbo-template/request.md`
- `workspace/changes/bootstrap-sync-turbo-template/specs/turbo-template-sync/spec.md`

**Key Decisions**:
1. TViewBuilder migration: Shell only (not all views)
2. Config values: All identifiers, URLs, Firebase IDs (with current defaults)
3. Script language: Dart CLI + Makefile targets
4. Change detection: Git commit hash comparison
5. Downstream sync: Leave project-only files untouched
6. Upstream sync: Revert to template defaults, respect sync_upwards whitelist
7. Script location: `turbo_template/scripts/` at template root

---

## Status Overview

```
1. 001-migrate-shell           🔴 NOT STARTED (refactor)
2. 002-create-config           🔴 NOT STARTED (infrastructure)
3. 003-init-script             🔴 NOT STARTED (infrastructure) [blocked: 002]
4. 004-downstream-sync         🔴 NOT STARTED (infrastructure) [blocked: 002,003]
5. 005-upstream-sync           🔴 NOT STARTED (infrastructure) [blocked: 002,003,004]
6. 006-validate-envs           🔴 NOT STARTED (chore) [blocked: 001]
7. 007-review                  🔴 NOT STARTED (chore) [blocked: all]
```

**Progress**: 0/7 tasks complete (0%)

---

## Detailed Status

### Task 001: Migrate ShellView to TViewBuilder
**Status**: 🔴 NOT STARTED
**Type**: refactor | **Skill**: junior

**Work**:
- [ ] Replace ViewModelBuilder with TViewBuilder in shell_view.dart
- [ ] Update imports
- [ ] Verify behavior unchanged

**Key File**: `turbo_template/flutter-app/lib/core/infrastructure/run-app/views/shell/shell_view.dart`

---

### Task 002: Create turbo_template_config.yaml
**Status**: 🔴 NOT STARTED
**Type**: infrastructure | **Skill**: medior

**Work**:
- [ ] Document all hardcoded values in template
- [ ] Create config file at template root
- [ ] Include sync metadata (template_path, last_commit_sync, sync_upwards)
- [ ] Remove flutter-app/template.yaml (consolidate)

**Key File**: `turbo_template/turbo_template_config.yaml` (new)

---

### Task 003: Create init_project.dart
**Status**: 🔴 NOT STARTED
**Type**: infrastructure | **Skill**: medior
**Blocked by**: 002

**Work**:
- [ ] Create Dart script for find-replace across template
- [ ] Handle binary files (skip)
- [ ] Add dry-run mode
- [ ] Add Makefile target

**Key Files**:
- `turbo_template/scripts/init_project.dart` (new)
- `turbo_template/scripts/pubspec.yaml` (new)

---

### Task 004: Create sync_from_template.dart
**Status**: 🔴 NOT STARTED
**Type**: infrastructure | **Skill**: senior
**Blocked by**: 002, 003

**Work**:
- [ ] Git diff to find changed files
- [ ] Copy with value replacement
- [ ] Update last_commit_sync
- [ ] Add Makefile target

**Key File**: `turbo_template/scripts/sync_from_template.dart` (new)

---

### Task 005: Create sync_to_template.dart
**Status**: 🔴 NOT STARTED
**Type**: infrastructure | **Skill**: senior
**Blocked by**: 002, 003, 004

**Work**:
- [ ] Filter to sync_upwards whitelist
- [ ] Revert values to template defaults
- [ ] Update last_commit_sync in both configs
- [ ] Add Makefile target

**Key File**: `turbo_template/scripts/sync_to_template.dart` (new)

---

### Task 006: Validate All Environments
**Status**: 🔴 NOT STARTED
**Type**: chore | **Skill**: medior
**Blocked by**: 001

**Work**:
- [ ] flutter analyze passes
- [ ] Build succeeds for all environments
- [ ] Shell view switching works

---

### Task 007: Review All Changes
**Status**: 🔴 NOT STARTED
**Type**: chore | **Skill**: senior
**Blocked by**: 001-006

**Work**:
- [ ] End-to-end test of all scripts
- [ ] Verify Makefile targets
- [ ] Final quality check

---

## Implementation Log

<!-- APPEND ONLY - Never modify or delete existing entries -->

### ══════════════════════════════════════════
### Checkpoint: Session 1 — 2026-01-20
### ══════════════════════════════════════════

**What was done**:
- Created change proposal `bootstrap-sync-turbo-template`
- Clarified all requirements via iterative questions
- Created 7 task files in workspace/tasks/
- Created spec delta for turbo-template-sync capability
- Validated change with `splx validate change --id bootstrap-sync-turbo-template --strict`

**Decisions made**:
- All decisions documented in request.md and Context section above

**Blockers/Issues**:
- None

**Next steps**:
- Get user approval on proposal
- Run `splx get task` to start first task (001-migrate-shell)

---

## Quick Reference

**Progress**: 0/7 tasks complete (0%)

**Commands**:
```bash
# Get next task
splx get task

# Complete current task
splx complete task --id <task-id>

# Validate change
splx validate change --id bootstrap-sync-turbo-template --strict

# View proposal
splx get change --id bootstrap-sync-turbo-template
```

---

## Resume Instructions

After compact, to continue:
1. Read this file completely
2. Run `splx get task` to see next available task
3. First unblocked tasks: 001 (shell migration) and 002 (config creation)
4. Start with 001 as it's simpler (junior skill level)
