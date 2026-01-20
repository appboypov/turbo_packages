# TURBO-19 Review Fixes

## Progress Tracker
- **Current Task**: COMPLETE
- **Status**: All tasks done
- **Last Updated**: 2026-01-20

---

## Checklist

### Critical Fixes

- [x] **1. Remove unused fields from home_view_model.dart** ✅
  - Location: `turbo_template/flutter-app/lib/core/infrastructure/navigate-app/views/home/home_view_model.dart`
  - Issue: `_homeRouter`, `_coreRouter`, `_dialogService`, `_sheetService`, `_toastService` are injected but never used
  - Action: Remove unused fields and their constructor parameters
  - **DONE**: Removed unused fields, imports, and constructor parameters

- [x] **2. Fix lastCommitSync null handling in config_reader.dart** ✅
  - Location: `turbo_template/scripts/lib/config_reader.dart:111`
  - Issue: Returns `"null"` string instead of Dart `null` when YAML value is literal `null`
  - Action: Check for string "null" and return actual null
  - **DONE**: Added `_parseNullableString()` helper function

- [x] **3. Remove dead `replacements` config section OR implement its usage** ✅
  - Location: `turbo_template/turbo_template_config.yaml:69-88` and `config_reader.dart`
  - Issue: Config section is parsed but never used by any script
  - Action: Remove from config and TemplateConfig class (dead code)
  - **DONE**: Removed `replacements` section from YAML, removed field from TemplateConfig, removed parsing logic

- [x] **4. Eliminate DefaultValues class duplication** ✅
  - Location: `turbo_template/scripts/init_project.dart:10-22`
  - Issue: Hardcoded defaults duplicate config values - two sources of truth
  - Action: Read default values from config file or define constants in one place
  - **DONE**: Moved `DefaultValues` to `TemplateDefaults` in config_reader.dart, used by both ConfigReader and init_project.dart

- [x] **5. Remove lib/generated/ from sync_upwards** ✅
  - Location: `turbo_template/turbo_template_config.yaml:58`
  - Issue: Generated code varies per project, syncing upstream pollutes template
  - Action: Remove from whitelist
  - **DONE**: Removed `lib/generated/` from sync_upwards array (done with task 3)

- [x] **6. Fix print statements in seed_auth_users.dart** ✅
  - Location: `turbo_template/flutter-app/scripts/seed_auth_users.dart`
  - Issue: Uses `print()` which triggers `avoid_print` lint
  - Action: This is a script file, add ignore comment or use stderr for scripts
  - **DONE**: Added `// ignore_for_file: avoid_print` (appropriate for CLI scripts)

---

## Completed

(Items move here after completion)

---

## Notes

- Review identified from comparing work done against Linear issue TURBO-19
- All fixes maintain scope integrity - no feature additions
