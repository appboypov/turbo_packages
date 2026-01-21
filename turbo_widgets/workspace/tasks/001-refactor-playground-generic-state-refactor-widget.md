---
status: done
skill-level: senior
parent-type: change
parent-id: refactor-playground-generic-state
type: refactor
blocked-by: []
---

# 🧱 Refactor TPlayground to generic stateful widget

Use this template for code restructuring without changing behavior.

**Title Format**: `🧱 Refactor <component> to <goal>`

**Examples**:
- 🧱 Refactor auth service to remove duplication
- 🧱 Simplify payment validation logic

---

## 🔗 Dependencies
> Which tasks need to be completed first (if any)?

- [ ] None - this is the first task

## 🎯 Refactoring Goal
> What technical improvement are we making?

Convert `TPlayground` from a stateless widget with external state management to a self-contained, generic stateful widget (`TPlayground<T extends TPlaygroundParameterModel>`) that manages all playground state internally.

## 📍 Current State
> What is the current code structure?

```text
lib/src/widgets/t_playground.dart:
- StatelessWidget with 20+ constructor parameters
- Receives ValueListenable<TPlaygroundParameterModel> from external view model
- Receives 15+ onXxxChanged callbacks for state updates
- Uses TPlaygroundChildBuilder typedef that receives TPlaygroundParameterModel
- All state managed externally by consumer
```

## 🎯 Target State
> What should the code structure look like after refactoring?

```text
lib/src/widgets/t_playground.dart:
- StatefulWidget with generic type parameter T extends TPlaygroundParameterModel
- Two required parameters: parametersBuilder (T Function()) and childBuilder (Widget Function(BuildContext, T))
- Optional initial value parameters with sensible defaults (initialScreenType, initialIsDarkMode, etc.)
- Internal state management in _TPlaygroundState<T>:
  - T _parameters (initialized from parametersBuilder in initState)
  - bool _isGeneratorOpen
  - TurboWidgetsScreenTypes _screenType
  - TurboWidgetsPreviewMode _previewMode
  - DeviceInfo? _selectedDevice
  - double _previewScale
  - bool _isDarkMode
  - bool _isSafeAreaEnabled
  - String _activeTab
  - String _userRequest
  - String _variations
  - String _instructions
  - bool _isParameterPanelExpanded
- Internal methods for state updates with setState
- Clipboard operations handled internally
```

## 💡 Justification
> Why is this refactoring needed?

- [x] Reduce API surface from 20+ parameters to 2 required + optional initial values
- [x] Remove coupling between TPlayground and external state management
- [x] Enable type-safe parameter access via generic type T
- [x] Simplify consumer code by eliminating callback wiring
- [x] Make playground self-contained as a prototyping tool should be

## 🚫 Behavior Changes
> Confirm: NO behavior changes

- [x] This refactoring does NOT change any external behavior
- [x] All existing tests should pass without modification (after updating to new API)
- [ ] No API/interface changes that affect consumers - **NOTE: This IS a breaking API change, intentionally**

## 📋 Refactoring Steps
> What steps will be taken?

1. [x] Add generic type parameter `<T extends TPlaygroundParameterModel>` to class declaration
2. [x] Convert from `StatelessWidget` to `StatefulWidget`
3. [x] Create `_TPlaygroundState<T>` with all internal state variables
4. [x] Replace constructor parameters:
   - Add `required T Function() parametersBuilder`
   - Add `required Widget Function(BuildContext, T) childBuilder`
   - Add optional `initialXxx` parameters with defaults
   - Remove `parametersListenable`, `onParametersChanged`, all `onXxxChanged` callbacks
5. [x] Implement `initState` to initialize state from widget properties
6. [x] Move all callback logic into internal methods with `setState`
7. [x] Update `TPlaygroundParameterPanel` wiring to use internal state and setter
8. [x] Update child builder invocation to pass typed `T` parameter
9. [x] Implement clipboard copy internally using `Clipboard.setData`
10. [x] Update typedef `TPlaygroundChildBuilder` to be generic or inline the type

## ✅ Completion Criteria
> How do we verify the refactoring is successful?

- [x] Widget compiles with new generic signature
- [x] All internal state updates trigger rebuilds correctly
- [x] Parameter panel updates internal state correctly
- [x] Child builder receives typed T parameter
- [x] Clipboard copy works internally
- [x] No external state management required by consumers
- [x] Code passes dart analyze with no errors

## 🚧 Constraints
> Any limitations or things to avoid?

- [x] Do not change public APIs - **OVERRIDE: Breaking change is acceptable**
- [x] Type safety: ensure T is properly typed throughout state management
- [x] The `updateX` methods on TPlaygroundParameterModel return base type; handle casting appropriately

## 📝 Notes
> Additional context if needed

The `updateX` methods on `TPlaygroundParameterModel` return `TPlaygroundParameterModel`, not `T`. Since state is internal to the widget, we can safely cast the result back to `T` when storing in state, knowing the underlying data structure is preserved. Alternatively, store as base type internally and only expose as `T` via childBuilder.
