# Architecture

## Overview

**Turbo Widgets** is a Flutter package providing reusable UI widgets, extensions, and animation utilities. The package follows a **component-based, stateless-first architecture** designed for maximum reusability and testability. It includes a sophisticated **Component Playground** system for rapid widget prototyping with AI-assisted development capabilities.

### Key Architectural Principles

- **Stateless by default**: Widgets accept primitive parameters and callbacks, promoting reusability
- **Composition over inheritance**: Widgets compose existing components rather than duplicating code
- **State-agnostic design**: Package doesn't include state management; integrates with any state solution
- **Primitive parameters pattern**: Widgets use `String`, `int`, `bool`, `VoidCallback`, `ValueChanged<T>` instead of domain objects
- **No build methods**: UI extracted into smaller composable widgets rather than private `_buildXxx()` methods

## Technology Stack

| Category | Technology | Version | Purpose |
|----------|-----------|---------|---------|
| **Framework** | Flutter | >=1.17.0 | UI framework |
| **SDK** | Dart | ^3.6.0 | Programming language |
| **UI Library** | shadcn_ui | ^0.43.3 | Design system components |
| **Animation** | flutter_animate | ^4.5.0 | Animation utilities |
| **Layout** | gap | ^3.0.0 | Spacing utilities |
| **Device Frames** | device_frame_plus | ^1.5.0 | Device frame previews |
| **Testing** | flutter_test | SDK | Widget testing |
| **Linting** | lints | ^6.0.0 | Code quality |

## Project Structure

```
turbo_widgets/
├── lib/
│   ├── src/
│   │   ├── constants/          # Default values and device configurations
│   │   │   ├── turbo_widgets_defaults.dart
│   │   │   └── turbo_widgets_devices.dart
│   │   ├── enums/              # Type-safe enumerations
│   │   │   ├── t_contextual_allow_filter.dart
│   │   │   ├── t_contextual_position.dart
│   │   │   ├── t_contextual_variation.dart
│   │   │   ├── turbo_widgets_preview_mode.dart
│   │   │   └── turbo_widgets_screen_types.dart
│   │   ├── models/              # Data models
│   │   │   └── playground/
│   │   │       ├── t_playground_parameter_model.dart
│   │   │       └── t_select_option.dart
│   │   └── widgets/             # Reusable UI components
│   │       ├── playground/      # Playground-specific widgets
│   │       │   ├── t_playground_component_wrapper.dart
│   │       │   ├── t_playground_parameter_field.dart
│   │       │   ├── t_playground_parameter_panel.dart
│   │       │   ├── t_playground_prompt_generator.dart
│   │       │   └── t_playground_screen_type_selector.dart
│   │       ├── t_collapsible_section.dart
│   │       ├── t_contextual_wrapper.dart
│   │       ├── t_markdown_file_item.dart
│   │       ├── t_playground.dart
│   │       ├── t_showcase_item.dart
│   │       ├── t_showcase_section.dart
│   │       └── t_shrink.dart
│   └── turbo_widgets.dart       # Public API exports
├── example/                     # Example application
│   └── lib/
│       ├── views/
│       │   └── styling/
│       │       ├── styling_view.dart
│       │       └── styling_view_model.dart
│       └── main.dart
├── test/                        # Unit and widget tests
├── workspace/                   # Project management
│   ├── ARCHITECTURE.md         # This file
│   ├── AGENTS.md               # AI agent instructions
│   └── specs/                   # Technical specifications
└── pubspec.yaml                # Package configuration
```

## Component Inventory

### DTOs / Models / Records / Entities

| Name | Path | Purpose | Key Fields |
|------|------|---------|------------|
| **TPlaygroundParameterModel** | `lib/src/models/playground/t_playground_parameter_model.dart` | Centralized immutable model for all playground component parameters | `strings`, `textAreas`, `ints`, `doubles`, `bools`, `dateTimes`, `dateRanges`, `times`, `selects` |
| **TSelectOption<T>** | `lib/src/models/playground/t_select_option.dart` | Generic wrapper for select/enum options in playground parameters | `value`, `options`, `labelBuilder` |

### Services / Providers / Managers

**None** - This is a presentation-layer widget library. Business logic services would be in separate packages or consuming applications.

### APIs / Repositories / Controllers / Data Sources

**None** - This package does not contain any APIs, repositories, controllers, or data sources. It is focused purely on UI components.

### Views / Pages / Screens

| Name | Path | Route | View Model | Purpose |
|------|------|-------|------------|---------|
| **StylingView** | `example/lib/views/styling/styling_view.dart` | Home (example app) | `StylingViewModel` | Main view showcasing the component playground with responsive preview capabilities |

### View Models / Hooks / Blocs / Cubits / Notifiers

| Name | Path | Type | Services Used | Purpose |
|------|------|------|--------------|---------|
| **StylingViewModel** | `example/lib/views/styling/styling_view_model.dart` | `TViewModel` (from `turbo_mvvm`) | None | Manages playground state using `TNotifier` instances for reactive state management |

**Note**: The package itself is state-agnostic. The example app demonstrates integration with external state management (`turbo_mvvm` + `turbo_notifiers`).

### Widgets / Components

#### Core Widgets

| Name | Path | Purpose | Key Features |
|------|------|---------|--------------|
| **TPlayground** | `lib/src/widgets/t_playground.dart` | Main component playground for testing and developing widgets | Live preview, parameter controls, AI prompt generation, responsive preview |
| **TCollapsibleSection** | `lib/src/widgets/t_collapsible_section.dart` | Expandable/collapsible section | Animated content reveal, title/subtitle support |
| **TContextualWrapper** | `lib/src/widgets/t_contextual_wrapper.dart` | Advanced layout wrapper for contextual content | Positions content at top/bottom/left/right, multiple variation layers, animated transitions |
| **TMarkdownFileItem** | `lib/src/widgets/t_markdown_file_item.dart` | Card component displaying markdown file preview | Header, content preview, "Open in App" action |
| **TShowcaseItem** | `lib/src/widgets/t_showcase_item.dart` | Displays a widget with styled title badge | Showcase components with titles |
| **TShowcaseSection** | `lib/src/widgets/t_showcase_section.dart` | Expandable section for organizing showcase items | Header, collapsible content |
| **TVerticalShrink** / **THorizontalShrink** | `lib/src/widgets/t_shrink.dart` | Animated show/hide widgets | Size and fade transitions (vertical and horizontal variants) |

#### Playground Components

| Name | Path | Purpose | Key Features |
|------|------|---------|--------------|
| **TPlaygroundComponentWrapper** | `lib/src/widgets/playground/t_playground_component_wrapper.dart` | Wraps preview components with device frames | Device frames, responsive sizing, theme switching, safe area controls |
| **TPlaygroundParameterPanel** | `lib/src/widgets/playground/t_playground_parameter_panel.dart` | Auto-generates form controls for playground parameters | Type-based field generation (string, int, bool, etc.) |
| **TPlaygroundPromptGenerator** | `lib/src/widgets/playground/t_playground_prompt_generator.dart` | Tabbed interface for AI prompt generation | Create, solidify, and clear canvas prompts |
| **TPlaygroundScreenTypeSelector** | `lib/src/widgets/playground/t_playground_screen_type_selector.dart` | Toolbar for playground settings | Screen type selection, preview mode, device frame, theme, scale, safe area |
| **TPlaygroundParameterField** | `lib/src/widgets/playground/t_playground_parameter_field.dart` | Collection of typed input fields | `TPlaygroundStringField`, `TPlaygroundTextAreaField`, `TPlaygroundIntField`, `TPlaygroundDoubleField`, `TPlaygroundBoolField`, `TPlaygroundDateTimeField`, `TPlaygroundDateRangeField`, `TPlaygroundTimeField`, `TPlaygroundSelectField<T>` |

### Enums / Constants / Config

#### Enums

| Name | Path | Values | Purpose |
|------|------|--------|---------|
| **TContextualAllowFilter** | `lib/src/enums/t_contextual_allow_filter.dart` | `all`, `top`, `bottom`, `left`, `right` | Filter for which positions are allowed to display contextual content |
| **TContextualPosition** | `lib/src/enums/t_contextual_position.dart` | `top`, `bottom`, `left`, `right` | Positions where contextual content can appear in TContextualWrapper |
| **TContextualVariation** | `lib/src/enums/t_contextual_variation.dart` | `primary`, `secondary`, `tertiary` | Variations for contextual content layers at the same position |
| **TurboWidgetsPreviewMode** | `lib/src/enums/turbo_widgets_preview_mode.dart` | `none`, `deviceFrame` | Preview mode for the TPlayground widget |
| **TurboWidgetsScreenTypes** | `lib/src/enums/turbo_widgets_screen_types.dart` | `mobile`, `tablet`, `desktop` | Screen type classifications for responsive design |

#### Constants

| Name | Path | Purpose | Key Values |
|------|------|---------|------------|
| **TurboWidgetsDefaults** | `lib/src/constants/turbo_widgets_defaults.dart` | Animation durations, timing constants, and AI instruction templates | `animation` (225ms), `hover` (100ms), `instructions`, `solidifyInstructions`, `clearCanvasInstructions` |
| **TurboWidgetsDevices** | `lib/src/constants/turbo_widgets_devices.dart` | Device mappings for each screen type | `deviceForScreenType()`, `devicesForScreenType()`, `mobileDevices`, `tabletDevices`, `desktopDevices` |

### Utils / Helpers / Extensions

**None** - Utility functions would be in separate packages or consuming applications.

### Routing / Navigation

**None** - This is a widget library. Routing would be handled by consuming applications.

### Schemas / Validators

**None** - Validation would be handled by consuming applications or separate validation packages.

## Architecture Patterns

### Component-Based Architecture

The package follows a **component-based architecture** with these key patterns:

1. **Stateless-First Widget Design**
   - Most widgets are `StatelessWidget` with primitive parameters
   - `StatefulWidget` used sparingly for temporary UI state (animations, user input)
   - No private `_buildXxx()` methods; UI extracted into smaller composable widgets

2. **Composition Over Inheritance**
   - Widgets compose existing Flutter widgets (`AnimatedSize`, `AnimatedSwitcher`, `Stack`)
   - Custom widgets wrap and enhance base functionality
   - Heavy reuse of Flutter's built-in widgets

3. **Primitive Parameters Pattern**
   - Widgets accept primitive types (`String`, `int`, `bool`) instead of domain objects
   - Callbacks for user interactions (`VoidCallback`, `ValueChanged<T>`)
   - Promotes reusability and Widgetbook compatibility

4. **ValueListenable Integration**
   - Widgets can accept `ValueListenable<T>` for reactive updates
   - `TPlayground` uses `ValueListenableBuilder` to react to parameter changes
   - Enables integration with any reactive state management solution

### State Management Approach

**Package is state-agnostic** - The package itself does not include state management. Widgets are designed to work with any state management solution.

**Example App Pattern** (demonstrates integration):
- Uses **TViewModel** (from `turbo_mvvm` package) for business logic
- Uses **TNotifier** (from `turbo_notifiers` package) for reactive state
- ViewModels manage state; widgets receive state as constructor parameters
- Callbacks (`ValueChanged<T>`, `VoidCallback`) trigger state mutations

### Animation State Management

Animation state is managed locally in `StatefulWidget` instances when needed:
- `TContextualWrapper` uses `AnimationController` for position transitions
- `TShowcaseSection` uses `AnimationController` for expand/collapse animations
- Animation controllers are disposed in widget lifecycle methods

## Data Flow

### Playground Parameter Flow

```
ViewModel (TNotifier<TPlaygroundParameterModel>)
    ↓ (ValueListenable)
TPlayground (parametersListenable)
    ↓ (ValueListenableBuilder)
childBuilder(context, model)
    ↓ (extracts values from model)
Preview Widget (receives primitive parameters)
    ↓ (user interaction)
Parameter Panel (TPlaygroundParameterField)
    ↓ (onParametersChanged callback)
ViewModel (updates TNotifier)
    ↓ (triggers rebuild)
ValueListenableBuilder rebuilds preview
```

### State Flow Pattern

1. **State lives in ViewModels** (external to package)
   - Business logic and application state managed externally
   - `TNotifier` instances hold reactive state

2. **Widgets receive state from above**
   - Passed as constructor parameters
   - Can accept `ValueListenable<T>` for reactive updates

3. **Callbacks for mutations**
   - Widgets call callbacks (`ValueChanged<T>`, `VoidCallback`) to trigger state changes
   - ViewModels handle mutations

4. **Reactive updates**
   - `ValueListenableBuilder` rebuilds widgets when `ValueListenable` changes
   - No direct state management in package widgets

## Dependency Graph

### Package Dependencies

```
turbo_widgets
├── flutter (SDK)
├── device_frame_plus (device frames)
├── flutter_animate (animations)
├── gap (spacing)
└── shadcn_ui (design system)
```

### Internal Dependencies

```
TPlayground
├── TPlaygroundComponentWrapper
├── TPlaygroundParameterPanel
│   └── TPlaygroundParameterField (various types)
├── TPlaygroundPromptGenerator
└── TPlaygroundScreenTypeSelector

TContextualWrapper
└── TShrink (for animations)

TShowcaseSection
└── TCollapsibleSection
    └── TShowcaseItem
```

### Example App Dependencies

```
TurboWidgetsExampleApp
└── StylingView
    ├── StylingViewModel (turbo_mvvm)
    │   └── TNotifier instances (turbo_notifiers)
    └── TPlayground
        └── (all playground widgets)
```

## Configuration

### Package Configuration

- **pubspec.yaml**: Package metadata, dependencies, SDK constraints
- **analysis_options.yaml**: Dart analyzer configuration
- **lib/turbo_widgets.dart**: Public API exports

### Runtime Configuration

- **TurboWidgetsDefaults**: Animation durations, AI instruction templates
- **TurboWidgetsDevices**: Device frame configurations per screen type
- **TPlaygroundParameterModel**: Parameter type definitions (configured by consuming app)

### Theme Configuration

Widgets use **shadcn_ui** theme system:
- `ShadThemeData` for theme configuration
- Theme-aware colors via `theme.colorScheme`
- Automatic light/dark mode support
- No hardcoded colors; all colors from theme

## Testing Structure

### Test Organization

```
test/
└── turbo_widgets_test.dart    # Package tests
```

### Testing Approach

- **Widget tests**: Test widget rendering and interactions
- **Golden tests**: Visual regression testing (if configured)
- **Example app**: Manual testing and demonstration

### Testing Patterns

- Test widgets with primitive parameters
- Mock callbacks to verify interactions
- Test animations with `WidgetTester.pumpAndSettle()`
- Test theme variations (light/dark)

## Conventions

### Naming Conventions

- **Widgets**: PascalCase with `T` prefix (e.g., `TPlayground`, `TCollapsibleSection`)
- **Models**: PascalCase with `T` prefix (e.g., `TPlaygroundParameterModel`)
- **Enums**: PascalCase with `T` prefix or descriptive name (e.g., `TContextualPosition`, `TurboWidgetsScreenTypes`)
- **Constants**: PascalCase (e.g., `TurboWidgetsDefaults`)
- **Files**: snake_case matching class name (e.g., `t_playground.dart`)

### Code Organization

- **One widget per file**: Each widget class in its own file
- **Feature folders**: Related widgets grouped (e.g., `playground/`)
- **Public API**: All exports in `lib/turbo_widgets.dart`
- **Private implementation**: `lib/src/` contains implementation details

### Widget Design Principles

1. **Stateless by default**: Only use `StatefulWidget` for temporary UI state
2. **Primitive parameters**: Use `String`, `int`, `bool`, `VoidCallback`, `ValueChanged<T>`
3. **No build methods**: Extract UI into smaller composable widgets
4. **Compose existing widgets**: Reuse before creating
5. **Theme-aware**: Use theme colors, never hardcode
6. **Accessible**: Support screen readers, proper contrast, focus indicators

### Error Handling

- **Assertions**: Use `assert()` for invalid parameter combinations
- **Null safety**: Leverage Dart's null safety features
- **Graceful degradation**: Widgets handle missing optional parameters
- **Documentation**: Clear parameter documentation with examples

## API Patterns

### External APIs

**None** - This package does not interact with external APIs.

### Internal APIs

#### Widget Public API

All widgets follow consistent patterns:

```dart
class TWidget extends StatelessWidget {
  const TWidget({
    required this.requiredParam,
    this.optionalParam,
    super.key,
  });

  final String requiredParam;
  final String? optionalParam;
}
```

#### Callback Patterns

- **VoidCallback**: For actions without parameters
- **ValueChanged<T>**: For value updates
- **TPlaygroundChildBuilder**: For reactive widget builders

#### ValueListenable Integration

```dart
ValueListenableBuilder<TPlaygroundParameterModel>(
  valueListenable: parametersListenable,
  builder: (context, model, _) => childBuilder(context, model),
)
```
