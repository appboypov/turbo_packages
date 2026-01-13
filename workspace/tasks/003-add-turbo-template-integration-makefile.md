---
status: done
skill-level: junior
parent-type: change
parent-id: add-turbo-template-integration
---

# Task: Add Makefile targets

## End Goal

Makefile provides `sync-template` and `setup-hooks` targets for easy access.

## Currently

Makefile has no targets for template syncing or hook setup.

## Should

- `make sync-template` manually syncs template to target
- `make setup-hooks` installs the post-commit hook

## Constraints

- [ ] Follow existing Makefile conventions
- [ ] Include help text for new targets

## Acceptance Criteria

- [ ] `make sync-template` runs the sync script
- [ ] `make setup-hooks` installs post-commit hook
- [ ] Both targets appear in `make help`

## Implementation Checklist

- [x] 3.1 Add sync-template target to Makefile
- [x] 3.2 Add setup-hooks target to Makefile
- [x] 3.3 Verify both appear in make help output

## Notes

None.
