---
status: completed
skill-level: medior
parent-type: change
parent-id: add-melos-pub-workflow
---

# Task: Implement Melos pub-check and pub-publish Scripts

## End Goal

Add `pub-check` and `pub-publish` scripts to Melos configuration that validate and publish packages to pub.dev. Developers can run `melos pub-check` to validate 160/160 pub points and `melos pub-publish` to publish.

## Currently

Root pubspec.yaml has Melos scripts for analyze, format, test, and build_runner. No publication workflow exists.

## Should

1. Add `pub-check` script to pubspec.yaml under melos.scripts
2. Add `pub-publish` script to pubspec.yaml under melos.scripts
3. Create wrapper shell scripts in tool/ directory to execute the pub workflow
4. Support --dry-run and --confirmed flags for publishing
5. Output clear validation status for each package

## Constraints

- [ ] Must use pana for 160/160 pub points validation
- [ ] Must validate packages sequentially (not in parallel) for clear error reporting
- [ ] Must not publish in CI environments (pub-check only)
- [ ] Must be portable and work on macOS, Linux, and CI runners
- [ ] Must output clear error messages when validation fails
- [ ] Must handle packages with no tests or platform-specific code

## Acceptance Criteria

- [ ] `melos pub-check` runs successfully and validates all 7 packages
- [ ] `melos pub-check` reports 160/160 pub points for each package (or fails with details)
- [ ] `melos pub-publish --dry-run` runs without publishing
- [ ] `melos pub-publish` (without flag) requires confirmation before publishing
- [ ] All scripts are defined in root pubspec.yaml under melos.scripts
- [ ] Wrapper scripts are in tool/ directory and executable
- [ ] Scripts handle package filtering and error cases gracefully

## Implementation Checklist

- [x] 1.1 Add pana as dev_dependency in root pubspec.yaml
- [x] 1.2 Create tool/pub_check.sh wrapper script
- [x] 1.3 Create tool/pub_publish.sh wrapper script
- [x] 1.4 Add pub-check Melos script to pubspec.yaml (melos.scripts)
- [x] 1.5 Add pub-publish Melos script to pubspec.yaml (melos.scripts)
- [x] 1.6 Test pub-check locally against all packages
- [x] 1.7 Test pub-publish --dry-run locally
- [x] 1.8 Verify scripts handle errors and edge cases

## Notes

- Pana must be installed as a dev dependency so melos can invoke it
- Scripts should validate in this order: conventions → docs → analysis → formatting → pana
- The --dry-run flag for pub-publish should run pana + dart pub publish --dry-run but not actually publish
- Consider using exec:concurrency: 1 in Melos to ensure sequential validation (easier to debug)
