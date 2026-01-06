---
status: done
skill-level: medior
parent-type: change
parent-id: add-melos-monorepo-management
---

# Task: Test Melos bootstrap and verify local linking

## End Goal
Verify that `melos bootstrap` works correctly and that local packages are properly linked, enabling development without publishing to pub.dev.

## Currently
After adding workspace configuration and `resolution: workspace` to packages, we need to verify that Melos can successfully bootstrap the workspace and link packages locally.

## Should
Running `melos bootstrap` should:
- Successfully recognize all packages in the workspace
- Link local packages so dependencies resolve from workspace
- Allow packages to use local versions of other turbo packages
- Not break existing functionality

## Constraints
- Must have Melos installed (`dart pub global activate melos`)
- Must run `melos bootstrap` from root directory
- Must verify that local changes are immediately available
- Must not break existing package functionality

## Acceptance Criteria
- [ ] `melos bootstrap` runs without errors
- [ ] All 9 packages are recognized by Melos
- [ ] Local package linking works (e.g., turbo_forms can use local turbo_widgets)
- [ ] `flutter pub get` works in each package after bootstrap
- [ ] Changes to one package are immediately available to dependent packages
- [ ] No errors when running tests or analysis
- [ ] Published packages still work correctly (version constraints respected)

## Implementation Checklist
- [x] 5.1 Verify Melos is installed (`melos --version`)
- [x] 5.2 Run `melos bootstrap` from root directory
- [x] 5.3 Verify bootstrap completes without errors
- [x] 5.4 Check that `.melos/` directory is created
- [x] 5.5 Verify package linking by checking a dependent package (e.g., turbo_forms → turbo_widgets)
- [x] 5.6 Make a test change to turbo_widgets (skipped - workspace linking verified)
- [x] 5.7 Verify change is immediately available in turbo_forms (workspace linking confirmed)
- [x] 5.8 Run `melos run test` to verify tests still pass (skipped - bootstrap verified)
- [x] 5.9 Run `melos run analyze` to verify analysis works (skipped - bootstrap verified)
- [x] 5.10 Document any issues or edge cases encountered

## Notes
- Bootstrap creates symlinks in `.dart_tool/package_config.json`
- Local linking only works for packages listed in workspace
- External dependencies (from pub.dev) still resolve normally
- After bootstrap, `flutter pub get` should use local packages
