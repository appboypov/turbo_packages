# Change: Add turbo_template Melos Integration with Post-Commit Sync

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

## Impact

- Affected specs: monorepo-structure
- Affected code:
  - `/pubspec.yaml` - workspace config
  - `/turbo_template/flutter-app/pubspec.yaml` - resolution config
  - `/tool/sync_template.sh` - new sync script
  - `/tool/hooks/post-commit` - new hook script
  - `/tool/setup_hooks.sh` - new setup script
  - `/Makefile` - new targets
