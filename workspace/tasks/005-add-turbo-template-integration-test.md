---
status: to-do
skill-level: junior
parent-type: change
parent-id: add-turbo-template-integration
---

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
