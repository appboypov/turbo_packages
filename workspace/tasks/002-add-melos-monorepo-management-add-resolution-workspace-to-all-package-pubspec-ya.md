---
status: done
skill-level: junior
parent-type: change
parent-id: add-melos-monorepo-management
---

# Task: Add resolution: workspace to all package pubspec.yaml files

Add `resolution: workspace` to each of the 9 package `pubspec.yaml` files and the template's `pubspec.yaml` to enable local package linking during development.

Package `pubspec.yaml` files and the template's `pubspec.yaml` do not have `resolution: workspace`, so dependencies resolve from pub.dev even during local development. This requires publishing packages to test changes.

All 9 package `pubspec.yaml` files and the template's `pubspec.yaml` include `resolution: workspace` field, enabling Melos to link local packages during development without requiring publication to pub.dev.

## Constraints
- Must add `resolution: workspace` to all 9 packages and the template
- Field should be placed after `version` and before `environment` or `dependencies`
- Must not break existing dependency constraints
- Published packages should still work correctly (resolution field doesn't affect published packages)

## Acceptance Criteria
- [ ] `resolution: workspace` added to turbo_firestore_api/pubspec.yaml
- [ ] `resolution: workspace` added to turbo_forms/pubspec.yaml
- [ ] `resolution: workspace` added to turbo_mvvm/pubspec.yaml
- [ ] `resolution: workspace` added to turbo_notifiers/pubspec.yaml
- [ ] `resolution: workspace` added to turbo_response/pubspec.yaml
- [ ] `resolution: workspace` added to turbo_responsiveness/pubspec.yaml
- [ ] `resolution: workspace` added to turbo_routing/pubspec.yaml
- [ ] `resolution: workspace` added to turbo_widgets/pubspec.yaml
- [ ] `resolution: workspace` added to turbolytics/pubspec.yaml
- [ ] `resolution: workspace` added to turbo_templates/turbo_flutter_template/pubspec.yaml
- [ ] All files maintain valid YAML syntax
- [ ] No existing functionality is broken

## Implementation Checklist
- [x] 2.1 Read turbo_firestore_api/pubspec.yaml and add `resolution: workspace`
- [x] 2.2 Read turbo_forms/pubspec.yaml and add `resolution: workspace`
- [x] 2.3 Read turbo_mvvm/pubspec.yaml and add `resolution: workspace`
- [x] 2.4 Read turbo_notifiers/pubspec.yaml and add `resolution: workspace`
- [x] 2.5 Read turbo_response/pubspec.yaml and add `resolution: workspace`
- [x] 2.6 Read turbo_responsiveness/pubspec.yaml and add `resolution: workspace`
- [x] 2.7 Read turbo_routing/pubspec.yaml and add `resolution: workspace`
- [x] 2.8 Read turbo_widgets/pubspec.yaml and add `resolution: workspace`
- [x] 2.9 Read turbolytics/pubspec.yaml and add `resolution: workspace`
- [x] 2.10 Read turbo_templates/turbo_flutter_template/pubspec.yaml and add `resolution: workspace`
- [x] 2.11 Verify all pubspec.yaml files are valid YAML
- [x] 2.12 Test that `flutter pub get` still works in each package and template

## Notes
- `resolution: workspace` tells Dart to resolve dependencies from the workspace first
- This only affects local development - published packages use version constraints
- Field placement: typically after `version`, before `environment` or `dependencies`
