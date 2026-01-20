---
status: done
skill-level: medior
parent-type: change
parent-id: bootstrap-sync-turbo-template
type: infrastructure
blocked-by:
  - 002-bootstrap-sync-turbo-template-create-config
---

# 🏗️ Set up init_project.dart script

## 🔗 Dependencies
> Which tasks need to be completed first (if any)?

- [ ] 002-bootstrap-sync-turbo-template-create-config

## 🎯 Infrastructure Goal
> What infrastructure capability are we adding or improving?

Create a Dart CLI script that initializes a project by replacing all template default values with project-specific values from the config file.

## 📍 Current State
> What is the current infrastructure setup?

No initialization script exists. Developers manually find-replace values after copying the template.

## 🎯 Target State
> What should the infrastructure look like after this work?

`turbo_template/scripts/init_project.dart` script that:
1. Reads `turbo_template_config.yaml`
2. Finds all template default values across the entire template
3. Replaces them with the configured project values
4. Handles binary files gracefully (skips them)
5. Is idempotent (safe to run multiple times)

## 🔧 Components
> What infrastructure components are involved?

### Script Features
- [ ] Read YAML config file
- [ ] Recursive file scanning (flutter-app, firebase, all directories)
- [ ] Text file detection (skip binary files)
- [ ] Find-replace logic for each configurable value
- [ ] Progress output showing files modified
- [ ] Dry-run mode (--dry-run flag)

### File Type Handling
- [ ] Process: .dart, .yaml, .json, .md, .txt, .xml, .gradle, .plist, .pbxproj, .sh
- [ ] Skip: .png, .jpg, .gif, .ico, .ttf, .otf, .woff, .woff2, .pdf, .jar, .aar

### CLI Interface
- [ ] `dart run scripts/init_project.dart` - run initialization
- [ ] `dart run scripts/init_project.dart --dry-run` - preview changes
- [ ] `dart run scripts/init_project.dart --verbose` - detailed output

## 🔐 Security Considerations
> What security measures are needed?

- [ ] Validate config file exists before processing
- [ ] Confirm destructive operation with user (unless --yes flag)
- [ ] Create backup of modified files (optional --backup flag)

## 📋 Configuration Files
> What configuration files will be created/modified?

| File | Purpose |
|------|---------|
| `scripts/init_project.dart` | Main initialization script |
| `scripts/lib/config_reader.dart` | YAML config parsing utilities |
| `scripts/lib/file_processor.dart` | File scanning and replacement logic |
| `scripts/pubspec.yaml` | Script dependencies (yaml, args packages) |
| `Makefile` | Add `init` target |

## ✅ Completion Criteria
> How do we verify the infrastructure is working?

- [ ] Script runs without errors on a fresh template copy
- [ ] All occurrences of default values are replaced
- [ ] Binary files are not corrupted
- [ ] Script is idempotent (running twice produces same result)
- [ ] `make init` target works

## 🚧 Constraints
> Any limitations or things to avoid?

- [ ] Do not modify files outside the template directory
- [ ] Do not auto-commit changes (leave that to user)
- [ ] Keep script self-contained (minimal external dependencies)

## 📝 Notes
> Additional context if needed

The script should use dart:io for file operations. Consider using the `yaml` package for config parsing and `args` for CLI argument handling.
