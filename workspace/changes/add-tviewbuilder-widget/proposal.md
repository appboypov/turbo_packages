# Change: Add TViewBuilder Widget with Contextual Button Support

## Why

Developers currently need to manually compose TViewModelBuilder with TContextualButtons for every view that needs contextual actions, leading to repetitive boilerplate. A convenience wrapper that combines both widgets with sensible defaults will streamline view creation and promote consistent patterns across the codebase.

## What Changes

- Create `TurboMvvmConstants` class in turbo_mvvm package to centralize TViewModelBuilder defaults
- Update TViewModelBuilder to use TurboMvvmConstants for default parameter values
- Create `TViewBuilder` widget in turbo_widgets package that wraps TContextualButtons → TViewModelBuilder
- TViewBuilder exposes all TViewModelBuilder parameters plus TContextualButtons' service parameter
- Pure composition approach - no new behavior, just convenient packaging

## Impact

- **Affected packages**:
  - `turbo_mvvm` (add constants, update TViewModelBuilder defaults)
  - `turbo_widgets` (add TViewBuilder widget, add turbo_mvvm dependency)
- **Affected code**:
  - `turbo_mvvm/lib/widgets/t_view_model_builder.dart` (use constants for defaults)
  - `turbo_widgets/lib/turbo_widgets.dart` (export new widget)
- **Developer experience**: Simplifies common pattern of views with contextual buttons
- **No breaking changes**: Existing TViewModelBuilder and TContextualButtons usage unchanged
