---
status: done
skill-level: medior
parent-type: change
parent-id: bootstrap-sync-turbo-template
type: infrastructure
blocked-by: []
---

# 🏗️ Set up turbo_template_config.yaml

## 🔗 Dependencies
> Which tasks need to be completed first (if any)?

- [ ] None

## 🎯 Infrastructure Goal
> What infrastructure capability are we adding or improving?

Create a centralized `turbo_template_config.yaml` at the template root that contains all configurable string values and sync metadata. This extends the existing `flutter-app/template.yaml` to cover the entire template.

## 📍 Current State
> What is the current infrastructure setup?

- `flutter-app/template.yaml` exists with basic name/organization/description
- Hardcoded values scattered across the codebase:
  - Package name: `turbo_flutter_template`
  - Organization: `app.apewpew`
  - Various Firebase project IDs
  - URLs for privacy policy, terms of service
- No sync metadata exists

## 🎯 Target State
> What should the infrastructure look like after this work?

- `turbo_template_config.yaml` at template root with:
  - All configurable string values with current defaults
  - `template_path` for sync operations
  - `last_commit_sync` for change detection
  - `sync_upwards` array for upstream sync whitelist
- `flutter-app/template.yaml` removed (consolidated into root config)

## 🔧 Components
> What infrastructure components are involved?

### Configuration File Structure
- [ ] App identifiers section (name, package_name, organization, description)
- [ ] URLs section (privacy_policy, terms_of_service, support)
- [ ] Firebase section (staging_project_id, prod_project_id)
- [ ] Sync metadata section (template_path, last_commit_sync, sync_upwards)

### Value Mapping
- [ ] Document all current hardcoded values and their locations
- [ ] Create replacements mapping (old_value → config key)

### File Locations to Scan
- [ ] flutter-app/pubspec.yaml
- [ ] flutter-app/android/app/build.gradle
- [ ] flutter-app/android/app/src/*/google-services.json
- [ ] flutter-app/ios/Runner.xcodeproj/project.pbxproj
- [ ] flutter-app/ios/Runner/Info.plist
- [ ] flutter-app/lib/**/*.dart
- [ ] firebase/firebase.json
- [ ] firebase/.firebaserc

## 🔐 Security Considerations
> What security measures are needed?

- [ ] No API keys or secrets in config (only project IDs and identifiers)
- [ ] Config file is safe to commit to git
- [ ] Document which values are sensitive vs. non-sensitive

## 📋 Configuration Files
> What configuration files will be created/modified?

| File | Purpose |
|------|---------|
| `turbo_template_config.yaml` | New centralized config at template root |
| `flutter-app/template.yaml` | Remove (consolidated) |
| `.gitignore` | Ensure config is NOT ignored |

## ✅ Completion Criteria
> How do we verify the infrastructure is working?

- [ ] turbo_template_config.yaml exists at template root
- [ ] All current hardcoded values are documented in config as defaults
- [ ] Config includes all sync metadata fields
- [ ] flutter-app/template.yaml is removed
- [ ] Config file is committed to git

## 🚧 Constraints
> Any limitations or things to avoid?

- [ ] Do not change any actual code values yet (just create the config)
- [ ] Keep defaults exactly matching current codebase values

## 📝 Notes
> Additional context if needed

The config format should be YAML for consistency with flutter/dart tooling. Values in the `replacements` section use the format `default_value: config_key` to enable bidirectional find-replace.
