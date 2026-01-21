# Request: Refactor TPlayground to Generic Stateful Widget

## Source Input

User request:
> update the playground widget to: 1. become a T generic where T is an implementation of the parameter model 2. the child builder passes this model forward through their build method 3. the playground widget becomes stateful 4. all logic for handling playground parameters sits in the playground widget instead of the view model

## Current Understanding

### What Exists Today

**TPlayground** (`turbo_widgets/lib/src/widgets/t_playground.dart`):
- Stateless widget with 20+ parameters
- Receives `parametersListenable` (ValueListenable<TPlaygroundParameterModel>) from external view model
- Receives `onParametersChanged` callback to notify parent of changes
- Uses `TPlaygroundChildBuilder` typedef that receives `TPlaygroundParameterModel`
- Parameter state and logic lives in the view model (e.g., `StylingViewModel._componentParameters`)

**TPlaygroundParameterModel** (`turbo_widgets/lib/src/models/playground/t_playground_parameter_model.dart`):
- Concrete class with typed maps for strings, ints, doubles, bools, etc.
- Has `copyWith` and `updateX` methods for immutable updates
- Not designed for extension (no abstract base)

**Current Usage Pattern**:
- View model creates and holds `TNotifier<TPlaygroundParameterModel>`
- View model exposes this as listenable and provides setter method
- TPlayground receives both and wires up the parameter panel internally

### Requested Changes

1. **Generic Type Parameter**: `TPlayground<T extends TPlaygroundParameterModel>` instead of hardcoded `TPlaygroundParameterModel`
2. **Child Builder Signature**: Builder receives `T` instead of `TPlaygroundParameterModel`
3. **Stateful Widget**: Convert from `StatelessWidget` to `StatefulWidget`
4. **Internalized Parameter Logic**: Move parameter state management into the widget itself, removing need for external view model to manage it

## Identified Ambiguities

1. **Initial Value Source**: How should the widget receive its initial parameter values if state is internal? Factory function? Required parameter? Default empty?

2. **Subclass Compatibility**: Does `T extends TPlaygroundParameterModel` require creating an abstract base class, or should existing `TPlaygroundParameterModel` become the base?

3. **External Access to State**: Should the widget expose its internal state for external reads (e.g., via GlobalKey/controller pattern)? Or is state purely internal?

4. **Breaking Change Tolerance**: Is this a breaking change to the API acceptable? Current users pass `parametersListenable` + `onParametersChanged`. New API would be different.

5. **Update Method Propagation**: The `updateX` methods on `TPlaygroundParameterModel` return a new instance. How should the generic type handle updates? Does `T` need to implement specific update methods?

## Decisions

1. **Initial Value Source**: Consumer provides `parametersBuilder: T Function()` factory that creates the initial T instance. Widget calls this in `initState` and manages the state internally.

2. **Update Contract**: `TPlaygroundParameterModel` stays as concrete class. `T extends TPlaygroundParameterModel` means subclasses must use existing `updateX` methods which return the base type. Subclasses can override to return their own type if needed.

3. **State Access**: State is purely internal. The child builder is the only way to access parameter values. No external callbacks or controller pattern needed.

4. **Breaking Change**: Full breaking change is acceptable. Remove old API entirely (parametersListenable, onParametersChanged). This is a redesign for personal use; no backwards compatibility needed.

5. **Scope of State**: ALL playground UI state moves into the widget. This includes:
   - `isGeneratorOpen`
   - `screenType`
   - `previewMode`
   - `selectedDevice`
   - `previewScale`
   - `isDarkMode`
   - `isSafeAreaEnabled`
   - `activeTab`
   - `userRequest`
   - `variations`
   - `instructions`
   - `isParameterPanelExpanded`
   - The generic parameter model `T`

6. **Event Callbacks**: Widget handles everything internally including clipboard copy. No external action callbacks needed.

7. **Initial UI State**: Widget accepts optional initial value parameters for customization (initialScreenType, initialIsDarkMode, initialPreviewMode, etc.) with sensible defaults.

## Final Intent

Refactor `TPlayground` from a stateless widget with external state management to a self-contained, generic stateful widget:

### New Widget Signature
```dart
class TPlayground<T extends TPlaygroundParameterModel> extends StatefulWidget {
  const TPlayground({
    required this.parametersBuilder,
    required this.childBuilder,
    this.initialScreenType = TurboWidgetsScreenTypes.mobile,
    this.initialIsGeneratorOpen = true,
    this.initialPreviewMode = TurboWidgetsPreviewMode.none,
    this.initialIsDarkMode = false,
    this.initialIsSafeAreaEnabled = false,
    this.initialPreviewScale = 1.0,
    this.initialInstructions = TurboWidgetsDefaults.instructions,
    // ... other optional initial values
    super.key,
  });

  final T Function() parametersBuilder;
  final Widget Function(BuildContext context, T parameters) childBuilder;
  // Optional initial values for UI state...
}
```

### Key Changes
1. **Generic Type `T`**: Bound to `TPlaygroundParameterModel`, allowing subclasses with additional typed properties
2. **Stateful Widget**: Converts to `StatefulWidget` with internal `_TPlaygroundState<T>`
3. **Internal State Management**: All state lives in the widget:
   - Parameter model (`T`)
   - UI state (screenType, isDarkMode, previewMode, isGeneratorOpen, etc.)
4. **Factory-based Initialization**: `parametersBuilder: T Function()` creates initial parameter values
5. **Typed Child Builder**: `childBuilder` receives `T` instead of base `TPlaygroundParameterModel`
6. **Self-contained Actions**: Clipboard copy handled internally (no external callbacks)
7. **Removed External Dependencies**:
   - Remove `parametersListenable`
   - Remove `onParametersChanged`
   - Remove all `onXxxChanged` callbacks
   - Remove all current value parameters

### Usage Example (After)
```dart
TPlayground<TPlaygroundParameterModel>(
  parametersBuilder: () => TPlaygroundParameterModel(
    strings: {'title': 'Hello'},
    bools: {'isEnabled': true},
  ),
  childBuilder: (context, params) => MyWidget(
    title: params.strings['title'] ?? '',
    isEnabled: params.bools['isEnabled'] ?? false,
  ),
)
```

### Files to Modify
1. `turbo_widgets/lib/src/widgets/t_playground.dart` - Complete rewrite
2. `turbo_widgets/example/lib/views/styling/styling_view.dart` - Update usage
3. `turbo_widgets/example/lib/views/styling/styling_view_model.dart` - Remove playground state
