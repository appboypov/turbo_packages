---
status: done
skill-level: medior
parent-type: change
parent-id: add-melos-monorepo-management
---

# Task: Create melos.yaml with common scripts

## End Goal
Create a `melos.yaml` configuration file with scripts for common monorepo operations like testing, analyzing, formatting, and cleaning.

## Currently
There is no `melos.yaml` file, so developers cannot use Melos scripts to run commands across all packages efficiently.

## Should
A `melos.yaml` file exists with scripts for:
- Running tests across all packages
- Analyzing all packages
- Formatting all packages
- Cleaning build artifacts
- Other common operations

## Constraints
- Scripts should work with Flutter/Dart tooling
- Scripts should handle packages with and without example directories
- Scripts should provide clear output and error handling
- Scripts should be consistent with existing CI/CD workflows where applicable

## Acceptance Criteria
- [ ] `melos.yaml` file created in root directory
- [ ] `test` script runs `flutter test` in all packages
- [ ] `analyze` script runs `dart analyze lib/` in all packages
- [ ] `format` script runs `dart format lib/ test/` in all packages
- [ ] `clean` script removes build artifacts
- [ ] Scripts handle packages with example directories correctly
- [ ] Scripts provide aggregated output

## Implementation Checklist
- [x] 3.1 Create `melos.yaml` file in root directory
- [x] 3.2 Add `scripts` section
- [x] 3.3 Add `test` script that runs `flutter test`
- [x] 3.4 Add `analyze` script that runs `dart analyze lib/`
- [x] 3.5 Add `format` script that runs `dart format lib/ test/`
- [x] 3.6 Add `format:check` script that checks formatting without modifying files
- [x] 3.7 Add `clean` script that removes build directories
- [x] 3.8 Add script descriptions for clarity
- [x] 3.9 Test each script to ensure it works correctly
- [x] 3.10 Verify scripts handle packages with/without examples

## Notes
- Melos scripts can use `melos exec` to run commands in each package
- Scripts can filter packages using `--scope` or `--ignore` flags
- Consider adding scripts for common workflows like `bootstrap`, `version`, `publish`
- Scripts should be documented with descriptions
