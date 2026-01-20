# Request: Add TViewBuilder Widget

## Source Input

```
# ✨ Developer can use TViewBuilder with built-in contextual button support

End goal: TViewBuilder as replacement for TViewModelBuilder with opinionated implementation for contextual buttons
Currently: none exists
Should:
- expose same defaults as TViewModelBuilder - place all constants/defaults of turbo_mvvm in TurboMvvmConstants and then create the TViewBuilder with the same defaults
- place the TView in the turbo_widgets package
- first widget should be the TContextualButtons - expose these arguments to the TViewBuilder
- then the TViewModelBuilder with all the arguments passed down

User Story: As a 👨‍💻 Developer, I want to use a TViewBuilder widget that wraps TViewModelBuilder with opinionated contextual button support, so that I have a consistent and streamlined way to build views with contextual actions.

Acceptance Criteria:
- TurboMvvmConstants class exists with all TViewModelBuilder defaults
- TViewBuilder widget exists in turbo_widgets package
- TViewBuilder exposes TContextualButtons arguments
- TViewBuilder passes all arguments to TViewModelBuilder
- TViewBuilder uses the same defaults as TViewModelBuilder

Constraints:
- Must be placed in turbo_widgets package
- Must not duplicate default values across multiple locations
```

## Current Understanding

The request is to create a new TViewBuilder widget that:
1. Lives in the turbo_widgets package
2. Wraps TViewModelBuilder with built-in contextual button support
3. Centralizes all TViewModelBuilder defaults into a new TurboMvvmConstants class
4. Exposes TContextualButtons configuration at the TViewBuilder level
5. Passes through all TViewModelBuilder arguments

## Identified Ambiguities

1. **TContextualButtons widget existence**: Does TContextualButtons already exist, or does it need to be created as part of this work?

2. **Positioning of contextual buttons**: Where should the contextual buttons appear relative to the view content (top, bottom, overlay, custom positioning)?

3. **TurboMvvmConstants location**: Should TurboMvvmConstants be created in turbo_mvvm package (where defaults originate) or turbo_widgets package (where TViewBuilder will live)?

4. **Optional vs required contextual buttons**: Should contextual buttons be optional in TViewBuilder, or always present but potentially hidden/empty?

5. **Default button configuration**: What should be the default behavior when no contextual buttons are specified?

6. **Relationship with TViewModelBuilder**: Should TViewBuilder completely replace TViewModelBuilder usage in the codebase, or coexist as a higher-level convenience wrapper?

## Decisions

### Context Gathered from Codebase

**TContextualButtons:**
- Already exists in turbo_widgets package
- Full-featured widget with position support (top, bottom, left, right)
- Uses TContextualButtonsService for configuration management
- Supports animations and multiple variations (primary, secondary, tertiary)
- Configuration via TContextualButtonsConfig model

**TViewModelBuilder:**
- Exists in turbo_mvvm package
- Parameters: child, builder, viewModelBuilder, argumentBuilder, isReactive (default: true), shouldDispose (default: true), onDispose
- Part of t_view_model.dart file

**Constants:**
- turbo_mvvm has TMVVMDurations (timeout, minBusy)
- turbo_widgets has TurboWidgetsDefaults (animation durations, hover, throttle, debounce, etc.)

**Package Structure:**
- Both packages are in monorepo workspace
- turbo_mvvm depends only on flutter and provider
- turbo_widgets depends on flutter, device_frame_plus, flutter_animate, gap, shadcn_ui

### Decisions Made:

**1. TurboMvvmConstants Location: In turbo_mvvm package**
- Keeps defaults with TViewModelBuilder source
- TViewBuilder in turbo_widgets will import from turbo_mvvm
- This is acceptable since turbo_widgets is a higher-level package

**2. Contextual Buttons API: Copy TContextualButtons parameters**
- TViewBuilder will expose the same parameters as TContextualButtons
- TContextualButtons has: required child, optional service
- TViewBuilder will expose optional service parameter and pass it through to TContextualButtons

**3. Coexistence with TViewModelBuilder**
- Both widgets will coexist
- TViewModelBuilder remains in turbo_mvvm for direct use
- TViewBuilder lives in turbo_widgets as a higher-level convenience wrapper for the common pattern with contextual buttons

**4. Default Behavior for Contextual Buttons**
- Use the same default behavior as TContextualButtons
- When service is null, TContextualButtons falls back to TContextualButtonsService.instance singleton
- TViewBuilder simply passes the service parameter through

## Final Intent

### Package Changes

**turbo_mvvm Package:**
1. Create `lib/data/constants/turbo_mvvm_constants.dart`
2. Define `TurboMvvmConstants` class with all TViewModelBuilder defaults:
   - `isReactive = true`
   - `shouldDispose = true`
3. Update TViewModelBuilder to use TurboMvvmConstants for default values

**turbo_widgets Package:**
1. Create `lib/src/widgets/t_view_builder.dart`
2. TViewBuilder widget that:
   - Wraps TContextualButtons (from turbo_widgets)
   - Which wraps TViewModelBuilder (from turbo_mvvm)
   - Exposes ALL TViewModelBuilder parameters
   - Exposes TContextualButtons' service parameter
   - Uses TurboMvvmConstants for default values
   - Passes all parameters through to respective widgets

### Widget Structure

```dart
TViewBuilder(
  // TContextualButtons parameter
  service: contextualButtonsService, // optional

  // TViewModelBuilder parameters (all passed through)
  child: child,
  builder: builder,
  viewModelBuilder: viewModelBuilder,
  argumentBuilder: argumentBuilder,
  isReactive: TurboMvvmConstants.isReactive, // default
  shouldDispose: TurboMvvmConstants.shouldDispose, // default
  onDispose: onDispose,
)
```

### Implementation Flow
1. TViewBuilder wraps TContextualButtons
2. TContextualButtons' child is TViewModelBuilder
3. All parameters flow through appropriately
4. No behavior changes to existing widgets - pure composition

### Acceptance Criteria Met
- [x] TurboMvvmConstants class exists with all TViewModelBuilder defaults
- [x] TViewBuilder widget exists in turbo_widgets package
- [x] TViewBuilder exposes TContextualButtons service parameter
- [x] TViewBuilder passes all arguments to TViewModelBuilder
- [x] TViewBuilder uses the same defaults as TViewModelBuilder via TurboMvvmConstants
- [x] No duplicate default values across multiple locations
