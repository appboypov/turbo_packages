# Implementation Progress: add-turbo-template-integration

## Tasks Overview

- [~] Task 5: test (in-progress)

---

## Task 5: test

**Status:** in-progress
**Task ID:** 005-add-turbo-template-integration-test

### Context

<details>
<summary>Proposal Context (click to expand)</summary>

## Why

The `turbo_template` folder contains a Flutter app template that depends on turbo packages. It needs to:
1. Stay updated when turbo packages change (via melos workflows: analyze, format, test, build_runner)
2. Sync to `~/Repos/turbo-template` after commits that modify the template (for separate git repo management)

## What Changes

- Add `turbo_template/flutter-app` to melos workspace
- Configure flutter-app to use workspace resolution for turbo package dependencies
- Exclude template from pub-specific operations (pub-check, pub-publish)
- Create post-commit git hook that syncs template to external repo (only when turbo_template changes)
- Add `make sync-template` and `make setup-hooks` targets
</details>

### Task Details

# Task: Validate behavior

## End Goal

Verify all functionality works as expected.

## Currently

All implementation and review complete.

## Should

All melos commands and sync functionality work correctly.

## Constraints

- [ ] Do not make actual commits during testing (use dry runs where possible)

## Acceptance Criteria

- [ ] melos bootstrap succeeds and includes flutter-app
- [ ] melos analyze includes flutter-app
- [ ] melos pub-check skips flutter-app
- [ ] make sync-template syncs to target directory
- [ ] make setup-hooks installs hook
- [ ] Post-commit hook only triggers on turbo_template changes

## Implementation Checklist

- [ ] 5.1 Run `melos bootstrap` and verify flutter-app listed
- [ ] 5.2 Run `melos analyze` and verify flutter-app included
- [ ] 5.3 Run `melos pub-check` and verify flutter-app skipped
- [ ] 5.4 Run `make setup-hooks` and verify hook installed
- [ ] 5.5 Run `make sync-template` and verify files copied to target
- [ ] 5.6 Verify ~/Repos/turbo-template has synced content without build artifacts

## Notes

Test the post-commit hook by making a small change to turbo_template and committing.

### Agent Instructions

Pick up this task and implement it according to the specifications above.
Focus on the Constraints and Acceptance Criteria sections.
When complete, mark the task as done:

```bash
splx complete task --id 005-add-turbo-template-integration-test
```

---
