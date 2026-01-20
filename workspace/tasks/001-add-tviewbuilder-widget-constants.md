---
status: done
skill-level: junior
parent-type: change
parent-id: add-tviewbuilder-widget
type: chore
blocked-by: []
---

# 🧹 Create TurboMvvmConstants and update TViewModelBuilder

## 🔗 Dependencies
> Which tasks need to be completed first (if any)?

- [ ] None

## 🧹 Maintenance Area
> What part of the system needs attention?

The turbo_mvvm package needs constant centralization for TViewModelBuilder default values to avoid duplication when TViewBuilder is created.

## 📍 Current State
> What needs cleaning, updating, or removing?

- TViewModelBuilder uses inline default values (`isReactive = true`, `shouldDispose = true`)
- No centralized constants class exists in turbo_mvvm
- Defaults would need to be duplicated in turbo_widgets for TViewBuilder

## 🎯 Target State
> What should exist after this chore is complete?

- TurboMvvmConstants class exists in `turbo_mvvm/lib/data/constants/turbo_mvvm_constants.dart`
- Constants defined: `isReactive = true`, `shouldDispose = true`
- TViewModelBuilder updated to use TurboMvvmConstants for defaults
- Constants exported from turbo_mvvm package via `lib/turbo_mvvm.dart`

## 💡 Justification
> Why is this maintenance needed now?

Required to prevent default value duplication when TViewBuilder is created in turbo_widgets. Centralizing constants allows both TViewModelBuilder and TViewBuilder to reference the same source of truth.

## ✅ Completion Criteria
> How do we verify the chore is done?

- [ ] `turbo_mvvm/lib/data/constants/turbo_mvvm_constants.dart` file created
- [ ] TurboMvvmConstants class contains `isReactive` and `shouldDispose` static constants
- [ ] TViewModelBuilder constructor updated to use TurboMvvmConstants for defaults
- [ ] Constants exported from `turbo_mvvm/lib/turbo_mvvm.dart`
- [ ] No behavior changes to TViewModelBuilder (defaults remain true/true)
- [ ] All existing tests pass

## 🚧 Constraints
> Any limitations or things to avoid?

- [ ] Must not change default behavior (isReactive and shouldDispose must remain true)
- [ ] Must maintain backward compatibility with existing TViewModelBuilder usage
- [ ] Constants must be public and accessible from other packages

## 📝 Notes
> Additional context if needed

File should follow the pattern of existing constants file `TMVVMDurations` already in the package at `turbo_mvvm/lib/data/constants/t_mvvm_durations.dart`.
