# Widget Building Spec Delta

## ADDED Requirements

### Requirement: TurboMvvmConstants

The turbo_mvvm package SHALL provide a `TurboMvvmConstants` class that centralizes all TViewModelBuilder default parameter values.

#### Scenario: Constants defined for TViewModelBuilder
- **GIVEN** a developer imports turbo_mvvm
- **WHEN** they access TurboMvvmConstants
- **THEN** they can reference `isReactive` constant with value `true`
- **AND** they can reference `shouldDispose` constant with value `true`

### Requirement: TViewBuilder Widget

The turbo_widgets package SHALL provide a `TViewBuilder` widget that composes TContextualButtons wrapping TViewModelBuilder with all parameters exposed.

#### Scenario: TViewBuilder wraps both widgets
- **GIVEN** a developer wants to create a view with contextual buttons
- **WHEN** they use TViewBuilder
- **THEN** TContextualButtons wraps the content
- **AND** TViewModelBuilder provides the ViewModel to the builder

#### Scenario: All TViewModelBuilder parameters are exposed
- **GIVEN** a developer needs full TViewModelBuilder configuration
- **WHEN** they use TViewBuilder
- **THEN** they can pass child, builder, viewModelBuilder, argumentBuilder, isReactive, shouldDispose, and onDispose parameters
- **AND** these parameters flow through to TViewModelBuilder unchanged

#### Scenario: TContextualButtons service parameter is exposed
- **GIVEN** a developer needs custom contextual button service
- **WHEN** they use TViewBuilder with service parameter
- **THEN** the service is passed to TContextualButtons
- **AND** when service is null, TContextualButtons uses its default behavior (singleton instance)

#### Scenario: Default parameter values match TViewModelBuilder
- **GIVEN** a developer uses TViewBuilder without specifying optional parameters
- **WHEN** the widget builds
- **THEN** isReactive defaults to TurboMvvmConstants.isReactive (true)
- **AND** shouldDispose defaults to TurboMvvmConstants.shouldDispose (true)

## MODIFIED Requirements

### Requirement: TViewModelBuilder Default Values

The TViewModelBuilder widget SHALL use TurboMvvmConstants for default parameter values instead of inline literals.

#### Scenario: TViewModelBuilder uses constants for defaults
- **GIVEN** a developer uses TViewModelBuilder without specifying optional parameters
- **WHEN** the widget initializes
- **THEN** isReactive defaults to TurboMvvmConstants.isReactive
- **AND** shouldDispose defaults to TurboMvvmConstants.shouldDispose
- **AND** behavior remains identical to previous implementation
