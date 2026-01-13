---
status: done
skill-level: medior
parent-type: change
parent-id: add-turbo-template-integration
---

# Task: Create post-commit sync hook

## End Goal

After each commit that modifies turbo_template/, the template syncs to `~/Repos/turbo-template` automatically.

## Currently

No sync mechanism exists between this monorepo and the external template repo.

## Should

- Post-commit hook detects if turbo_template/ was changed in the commit
- If changed, runs sync script to copy template to target directory
- Target directory is configurable via `SYNC_TEMPLATE_TARGET` env var (default: ~/Repos/turbo-template)
- Excludes build artifacts, node_modules, Pods, etc.

## Constraints

- [ ] Only sync when turbo_template/ is actually modified
- [ ] Do not copy .git directory (target has its own)
- [ ] Exclude all build artifacts and caches
- [ ] Must work with untracked files (rsync, not git-based)

## Acceptance Criteria

- [ ] `tool/sync_template.sh` copies template excluding build artifacts
- [ ] `tool/hooks/post-commit` only triggers sync when turbo_template/ changed
- [ ] `tool/setup_hooks.sh` installs the hook to .git/hooks/
- [ ] Sync target is configurable via SYNC_TEMPLATE_TARGET env var
- [ ] Hook is tracked in git (tool/hooks/) and installed via setup script

## Implementation Checklist

- [x] 2.1 Create tool/sync_template.sh with rsync and exclusions
- [x] 2.2 Create tool/hooks/post-commit with change detection logic
- [x] 2.3 Create tool/setup_hooks.sh to install the hook
- [x] 2.4 Make all scripts executable (chmod +x)

## Notes

Exclusions:
- build/ - Flutter build output (~2.6GB)
- .dart_tool/ - Dart tooling cache
- node_modules/ - Firebase functions (~172MB)
- Pods/ - iOS CocoaPods (~151MB)
- .gradle/ - Android cache
- *.lock - Lock files
- .firebase/ - Emulator state
- coverage/ - Test coverage
- .idea/, .vscode/ - IDE configs
- .DS_Store - macOS metadata
- .git/ - Git directory
