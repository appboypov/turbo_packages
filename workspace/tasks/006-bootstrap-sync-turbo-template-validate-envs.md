---
status: done
skill-level: medior
parent-type: change
parent-id: bootstrap-sync-turbo-template
type: chore
blocked-by:
  - 001-bootstrap-sync-turbo-template-migrate-shell
---

# 🧹 Validate all environments run without errors

## 🔗 Dependencies
> Which tasks need to be completed first (if any)?

- [ ] 001-bootstrap-sync-turbo-template-migrate-shell

## 🧹 Maintenance Area
> What part of the system needs attention?

turbo_template environment configurations and runtime verification across all 4 environments: emulators, demo, staging, prod.

## 📍 Current State
> What needs cleaning, updating, or removing?

Environment configurations may have errors or warnings that haven't been tested. The TViewBuilder migration needs verification across all environments.

## 🎯 Target State
> What should exist after this chore is complete?

All 4 environments compile and run without errors:
- `make run-emulators` + Flutter app connects to emulators
- `--dart-define=env=demo` runs without errors
- `--dart-define=env=staging` compiles (may not connect without credentials)
- `--dart-define=env=prod` compiles (may not connect without credentials)

## 💡 Justification
> Why is this maintenance needed now?

Template must be validated as error-free before developers use it. The TViewBuilder migration needs to be verified in all runtime contexts.

## ✅ Completion Criteria
> How do we verify the chore is done?

- [ ] `flutter analyze` passes with no errors
- [ ] `flutter build apk --dart-define=env=emulators` succeeds
- [ ] `flutter build apk --dart-define=env=demo` succeeds
- [ ] `flutter build apk --dart-define=env=staging` succeeds
- [ ] `flutter build apk --dart-define=env=prod` succeeds
- [ ] App launches and shell correctly switches between auth/home views
- [ ] No runtime errors in debug console

## 🚧 Constraints
> Any limitations or things to avoid?

- [ ] Do not change environment logic, only fix actual errors
- [ ] Staging/prod may not be testable end-to-end without Firebase credentials

## 📝 Notes
> Additional context if needed

Focus on compilation and basic runtime verification. Full e2e testing with Firebase is out of scope - that requires project-specific credentials.
