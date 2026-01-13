# Change: Add turbo_template Melos Integration

## Why

The `turbo_template` folder contains a Flutter app template that depends on turbo packages. It needs to stay updated when turbo packages change via melos workflows (analyze, format, test, build_runner).

## What Changes

- Add `turbo_template/flutter-app` to melos workspace
- Configure flutter-app to use workspace resolution for turbo package dependencies
- Exclude template from pub-specific operations (pub-check, pub-publish)

## Impact

- Affected specs: monorepo-structure
- Affected code:
  - `/pubspec.yaml` - workspace config and melos script filters
  - `/turbo_template/flutter-app/pubspec.yaml` - resolution config
