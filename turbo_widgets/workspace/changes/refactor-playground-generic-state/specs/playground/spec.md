# Playground Capability

## MODIFIED Requirements

### Requirement: TPlayground Widget

The `TPlayground` widget SHALL be a generic stateful widget that manages all playground state internally.

#### Scenario: Generic type parameter
- **WHEN** declaring a TPlayground widget
- **THEN** it accepts a type parameter `T extends TPlaygroundParameterModel`
- **AND** the child builder receives the typed `T` parameter

#### Scenario: Internal state management
- **WHEN** TPlayground is instantiated
- **THEN** all UI state is managed internally including:
  - Parameter model of type T
  - Screen type selection
  - Generator panel open/closed
  - Preview mode selection
  - Device frame selection
  - Preview scale
  - Dark mode toggle
  - Safe area toggle
  - Active tab selection
  - User request text
  - Variations count
  - Instructions text
  - Parameter panel expanded state

#### Scenario: Factory-based initialization
- **WHEN** TPlayground is created
- **THEN** it requires a `parametersBuilder: T Function()` parameter
- **AND** calls this factory in initState to create initial parameter values

#### Scenario: Optional initial values
- **WHEN** TPlayground is created
- **THEN** it accepts optional parameters for initial UI state:
  - initialScreenType (default: mobile)
  - initialIsGeneratorOpen (default: true)
  - initialPreviewMode (default: none)
  - initialIsDarkMode (default: false)
  - initialIsSafeAreaEnabled (default: false)
  - initialPreviewScale (default: 1.0)
  - initialInstructions (default: TurboWidgetsDefaults.instructions)
  - initialUserRequest (default: '')
  - initialVariations (default: '1')
  - initialActiveTab (default: 'request')
  - initialIsParameterPanelExpanded (default: true)

#### Scenario: Self-contained clipboard
- **WHEN** user clicks copy prompt
- **THEN** TPlayground handles clipboard operations internally
- **AND** no external callback is required

## REMOVED Requirements

### Requirement: External State Management API

**Reason**: State management moved internal to widget.

**Migration**: Remove usage of:
- `parametersListenable` parameter
- `onParametersChanged` callback
- All `onXxxChanged` callbacks (screenType, previewMode, device, scale, darkMode, safeArea, generator, userRequest, variations, activeTab, instructions, copyPrompt, toggleParameterPanel)
- All current value parameters (passed as initialXxx instead)

Replace with:
- `parametersBuilder: T Function()` for initial parameter values
- `childBuilder: Widget Function(BuildContext, T)` for preview widget
- Optional `initialXxx` parameters for customizing initial UI state
