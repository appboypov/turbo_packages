---
status: to-do
skill-level: medior
parent-type: change
parent-id: add-turbo-template-integration
---

# Task: Add turbo_template to melos workspace

## End Goal

turbo_template/flutter-app participates in melos workflows (analyze, format, test, build_runner) but is excluded from pub-specific operations.

## Currently

- turbo_template exists as an untracked folder in the repo
- flutter-app uses pub.dev versions of turbo packages (turbo_response: ^1.0.1)
- melos workspace only includes publishable packages

## Should

- flutter-app is part of melos workspace
- flutter-app uses workspace resolution for turbo package dependencies
- melos pub-check and pub-publish skip flutter-app
- `melos bootstrap` includes flutter-app

## Constraints

- [ ] Do not break existing package workflows
- [ ] Template must remain functional as standalone when copied elsewhere

## Acceptance Criteria

- [ ] `melos bootstrap` includes turbo_flutter_template
- [ ] `melos analyze` includes flutter-app
- [ ] `melos format` includes flutter-app
- [ ] `melos test` runs flutter-app tests (if test dir exists)
- [ ] `melos pub-check` skips flutter-app
- [ ] `melos pub-publish` skips flutter-app

## Implementation Checklist

- [ ] 1.1 Add `turbo_template/flutter-app` to workspace list in root pubspec.yaml
- [ ] 1.2 Add `resolution: workspace` to flutter-app/pubspec.yaml
- [ ] 1.3 Update turbo_response dependency to use workspace (remove version)
- [ ] 1.4 Add packageFilters.ignore to pub-check script in melos config
- [ ] 1.5 Add packageFilters.ignore to pub-publish script in melos config
- [ ] 1.6 Add packageFilters.ignore to pub-publish-dry-run script in melos config
- [ ] 1.7 Run `melos bootstrap` and verify flutter-app is included

## Notes

The flutter-app SDK constraint (^3.9.2) is newer than root (^3.6.0) - melos allows mixed SDK constraints.
