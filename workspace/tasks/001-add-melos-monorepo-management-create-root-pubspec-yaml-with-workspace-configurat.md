---
status: done
skill-level: junior
parent-type: change
parent-id: add-melos-monorepo-management
---

# Task: Create root pubspec.yaml with workspace configuration

## End Goal
Create a root `pubspec.yaml` file that defines the workspace containing all 9 turbo packages, 1 template, and includes Melos as a development dependency.

## Currently
The root directory does not have a `pubspec.yaml` file. There is no workspace configuration, making it impossible to use Melos for monorepo management.

## Should
A root `pubspec.yaml` file exists with:
- Workspace definition listing all 9 packages
- Melos as a dev dependency
- Proper SDK version constraints
- `publish_to: none` to prevent accidental publishing

## Constraints
- Must include all 9 packages: turbo_firestore_api, turbo_forms, turbo_mvvm, turbo_notifiers, turbo_response, turbo_responsiveness, turbo_routing, turbo_widgets, turbolytics
- Must include the template: turbo_templates/turbo_flutter_template
- Must use Melos version compatible with current Dart SDK (^7.0.0)
- Must set `publish_to: none` to prevent root from being published
- SDK version should match or be compatible with package SDK versions

## Acceptance Criteria
- [ ] Root `pubspec.yaml` file created
- [ ] Workspace section lists all 9 packages
- [ ] Melos included as dev dependency (^7.0.0)
- [ ] `publish_to: none` is set
- [ ] SDK version is compatible with all packages
- [ ] File follows YAML formatting standards

## Implementation Checklist
- [x] 1.1 Create `pubspec.yaml` in root directory
- [x] 1.2 Add `name` field (e.g., `flutter_turbo_packages`)
- [x] 1.3 Add `publish_to: none`
- [x] 1.4 Add `environment` section with SDK version (^3.9.0)
- [x] 1.5 Add `workspace` section listing all 9 packages and 1 template:
  - turbo_firestore_api
  - turbo_forms
  - turbo_mvvm
  - turbo_notifiers
  - turbo_response
  - turbo_responsiveness
  - turbo_routing
  - turbo_widgets
  - turbolytics
  - turbo_templates/turbo_flutter_template
- [x] 1.6 Add `dev_dependencies` section with `melos: ^7.0.0`
- [x] 1.7 Verify YAML syntax is valid
- [x] 1.8 Test that `melos bootstrap` recognizes the workspace

## Notes
- Package names in workspace should match directory names exactly
- SDK version should be compatible with all packages (check package pubspec.yaml files)
- Melos 7.x uses workspace configuration in pubspec.yaml (not melos.yaml)
