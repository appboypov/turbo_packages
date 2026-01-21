# Proposal: Refactor TPlayground to Generic Stateful Widget

## Summary

Convert `TPlayground` from a stateless widget with external state management to a self-contained, generic stateful widget that manages all playground state internally.

## Motivation

The current `TPlayground` implementation requires consumers to:
- Manage 15+ state variables in their view models
- Wire up 20+ callbacks between the widget and view model
- Handle parameter model state externally

This creates unnecessary complexity and couples the widget tightly to external state management. The playground is a self-contained tool for widget prototyping and should manage its own state.

## Proposed Changes

### 1. Generic Type Parameter

```dart
// Before
class TPlayground extends StatelessWidget { ... }

// After
class TPlayground<T extends TPlaygroundParameterModel> extends StatefulWidget { ... }
```

### 2. New API Surface

**Required Parameters:**
- `parametersBuilder: T Function()` - Factory to create initial parameter values
- `childBuilder: Widget Function(BuildContext, T)` - Builder receiving typed parameters

**Optional Initial Values (with defaults):**
- `initialScreenType` (default: `TurboWidgetsScreenTypes.mobile`)
- `initialIsGeneratorOpen` (default: `true`)
- `initialPreviewMode` (default: `TurboWidgetsPreviewMode.none`)
- `initialIsDarkMode` (default: `false`)
- `initialIsSafeAreaEnabled` (default: `false`)
- `initialPreviewScale` (default: `1.0`)
- `initialInstructions` (default: `TurboWidgetsDefaults.instructions`)
- `initialUserRequest` (default: `''`)
- `initialVariations` (default: `'1'`)
- `initialActiveTab` (default: `'request'`)
- `initialIsParameterPanelExpanded` (default: `true`)

### 3. Removed API Surface

All external state management removed:
- `parametersListenable`
- `onParametersChanged`
- `onScreenTypeChanged`
- `onPreviewModeChanged`
- `onDeviceChanged`
- `onPreviewScaleChanged`
- `onToggleDarkMode`
- `onToggleSafeArea`
- `onToggleGenerator`
- `onUserRequestChanged`
- `onVariationsChanged`
- `onActiveTabChanged`
- `onInstructionsChanged`
- `onCopyPrompt`
- `onToggleParameterPanel`

### 4. Internal State Management

The widget state class manages:
- All UI state (screenType, isDarkMode, previewMode, etc.)
- Parameter model of type `T`
- Internal methods for state updates
- Clipboard operations

## Impact

### Files Modified

| File | Change Type | Description |
|------|-------------|-------------|
| `lib/src/widgets/t_playground.dart` | Rewrite | Convert to generic stateful widget |
| `example/lib/views/styling/styling_view.dart` | Update | Simplify to use new API |
| `example/lib/views/styling/styling_view_model.dart` | Cleanup | Remove playground-related state |

### Breaking Changes

This is a breaking change to the `TPlayground` API. All existing usages must be updated. Since this is for personal use only, this is acceptable.

## Tasks

1. **🧱 Refactor TPlayground to generic stateful widget** - Core widget conversion
2. **🧹 Remove playground state from StylingViewModel** - Cleanup obsolete code
3. **🔧 Update StylingView to use new TPlayground API** - Integration

## Risks & Mitigations

| Risk | Mitigation |
|------|------------|
| Type casting issues with `T` and `updateX` methods | The `updateX` methods return base type; widget state casts appropriately since it's internal |
| Lost functionality | All current functionality preserved; just moved into widget |

## Decision

Proceed with implementation.
