---
status: done
skill-level: junior
parent-type: change
parent-id: bootstrap-sync-turbo-template
type: refactor
blocked-by: []
---

# 🧱 Refactor ShellView to use TViewBuilder

## 🔗 Dependencies
> Which tasks need to be completed first (if any)?

- [ ] None

## 🎯 Refactoring Goal
> What technical improvement are we making?

Migrate ShellView from using `ViewModelBuilder<ShellViewModel>` (from veto) to `TViewBuilder<ShellViewModel>` (from turbo_widgets) for consistency with the turbo_widgets package.

## 📍 Current State
> What is the current code structure?

```text
turbo_template/flutter-app/lib/core/infrastructure/run-app/views/shell/shell_view.dart
- Uses ViewModelBuilder<ShellViewModel> from veto package
- Wraps ValueListenableBuilder<ViewType> for view switching
```

## 🎯 Target State
> What should the code structure look like after refactoring?

```text
turbo_template/flutter-app/lib/core/infrastructure/run-app/views/shell/shell_view.dart
- Uses TViewBuilder<ShellViewModel> from turbo_widgets package
- Same internal ValueListenableBuilder<ViewType> for view switching
- Behavior identical, only outer wrapper changed
```

## 💡 Justification
> Why is this refactoring needed?

- [ ] Consistency: TViewBuilder is the turbo_widgets standard for view/viewmodel binding
- [ ] Future-proofing: TViewBuilder includes TContextualButtons integration
- [ ] Template standardization: Projects using turbo_template should follow turbo_widgets patterns

## 🚫 Behavior Changes
> Confirm: NO behavior changes

- [ ] This refactoring does NOT change any external behavior
- [ ] All existing tests should pass without modification
- [ ] No API/interface changes that affect consumers

## 📋 Refactoring Steps
> What steps will be taken?

1. [ ] Add turbo_widgets import to shell_view.dart
2. [ ] Replace `ViewModelBuilder<ShellViewModel>` with `TViewBuilder<ShellViewModel>`
3. [ ] Update builder signature to match TViewBuilder API
4. [ ] Remove veto import if no longer needed
5. [ ] Verify app compiles and runs correctly

## ✅ Completion Criteria
> How do we verify the refactoring is successful?

- [ ] All existing tests pass
- [ ] No behavior changes detected
- [ ] Code structure matches target state
- [ ] Shell correctly switches between auth and home views

## 🚧 Constraints
> Any limitations or things to avoid?

- [ ] Do not change public APIs
- [ ] Do not modify ShellViewModel - only ShellView
- [ ] Keep the inner ValueListenableBuilder pattern unchanged

## 📝 Notes
> Additional context if needed

TViewBuilder wraps TContextualButtons around TViewModelBuilder. The service parameter is optional and defaults to the singleton instance.
