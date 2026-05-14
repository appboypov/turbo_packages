# Architecture — turbo_forms

Type-safe form field configuration and validation for Flutter with ShadCN UI integration.

## Technology Stack

| Technology | Version | Purpose |
|---|---|---|
| Dart | ^3.10.4 | Language |
| Flutter | >=1.17.0 | UI framework |
| equatable | ^2.0.5 | Value equality for form field state |
| shadcn_ui | ^0.54.0 | UI controllers (text, select, time picker, slider) |
| turbo_notifiers | ^1.1.0 | Reactive state notification (`TNotifier`) |
| turbolytics | ^1.1.0 | Logging mixin for field lifecycle events |

## Project Structure

```
turbo_forms/
├── example/
│   └── example.dart                        # Login form usage example
├── lib/
│   ├── turbo_forms.dart                    # Barrel file (public API)
│   └── src/
│       ├── abstracts/
│       │   └── t_form_config.dart          # Abstract form config with DTO support
│       ├── config/
│       │   ├── t_form_field_config.dart    # Reactive field config (TNotifier-based)
│       │   ├── t_form_field_extensions.dart # Part: string field extensions
│       │   └── t_form_field_state.dart     # Part: immutable field state snapshot
│       ├── constants/
│       │   └── turbo_forms_defaults.dart   # Animation/layout defaults
│       ├── enums/
│       │   └── t_field_type.dart           # 20 supported field types
│       ├── extensions/
│       │   └── turbo_form_field_extensions.dart # Num/String/Object utilities
│       ├── typedefs/
│       │   ├── t_form_field_builder_def.dart   # Builder callback typedef
│       │   └── values_validator_def.dart        # Multi-value validator typedef
│       └── widgets/
│           ├── t_error_label.dart           # Animated error display
│           ├── t_form_field.dart            # Composite form field widget
│           ├── t_form_field_builder.dart    # ValueListenableBuilder wrapper
│           └── vertical_shrink.dart         # Expand/collapse animation
└── pubspec.yaml
```

## Architecture Patterns

**Pattern:** Configuration-driven form management. Each form is a `TFormConfig<DTO>` subclass that declares `TFormFieldConfig` instances keyed by enum identifiers. Field configs are reactive (`TNotifier`-based) and manage their own value, validation, controllers, and focus state.

**State management:** `TFormFieldConfig<T>` extends `TNotifier<TFormFieldState<T>>` — field state is an immutable `Equatable` snapshot; mutations go through `update()`/`updateCurrent()` which notify listeners.

**Validation:** Per-field via `FormFieldValidator<T>` (single value) or `ValuesValidatorDef<T>` (multi-value). Form-level via `TFormConfig.isValid` which iterates enabled+visible fields.

**Controller ownership:** `TFormFieldConfig` owns ShadCN controllers (`ShadTextEditingController`, `ShadSelectController`, `ShadTimePickerController`, `ShadSliderController`) and `FocusNode`, created based on `TFieldType` and disposed in `TFormFieldConfig.dispose()`.

## Component Inventory

### Abstract Classes

| Name | Path | Purpose |
|---|---|---|
| TFormConfig\<DTO\> | lib/src/abstracts/t_form_config.dart | Base class for form definitions; holds DTO, validates all fields, manages lifecycle |

### Config / State

| Name | Path | Purpose |
|---|---|---|
| TFormFieldConfig\<T\> | lib/src/config/t_form_field_config.dart | Reactive field config managing value, validation, controllers, focus |
| TFormFieldState\<T\> | lib/src/config/t_form_field_state.dart | Immutable state snapshot for a single field (Equatable) |

### Enums

| Name | Path | Purpose |
|---|---|---|
| TFieldType | lib/src/enums/t_field_type.dart | 20 field types determining controller creation and value cardinality |

### Constants

| Name | Path | Purpose |
|---|---|---|
| TurboFormsDefaults | lib/src/constants/turbo_forms_defaults.dart | Animation durations, sizing, curves, layout defaults |

### Extensions

| Name | Path | Purpose |
|---|---|---|
| FormFieldConfigStringExtension | lib/src/config/t_form_field_extensions.dart | Convenience on `TFormFieldConfig<String>` (trimmed empty check) |
| TurboFormNumExtension | lib/src/extensions/turbo_form_field_extensions.dart | `tHasDecimals` for numeric handling |
| TurboFormStringExtension | lib/src/extensions/turbo_form_field_extensions.dart | Parsing (`tTryAsDouble`, `tTryAsInt`), normalization (`tNaked`), empty check |
| TurboFormObjectExtension | lib/src/extensions/turbo_form_field_extensions.dart | Generic type cast (`tAsType<E>()`) |

### Typedefs

| Name | Path | Purpose |
|---|---|---|
| TFormFieldBuilderDef\<T\> | lib/src/typedefs/t_form_field_builder_def.dart | Builder callback for constructing field UI from config |
| ValuesValidatorDef\<T\> | lib/src/typedefs/values_validator_def.dart | Validator for multi-value fields |

### Widgets

| Name | Path | Purpose |
|---|---|---|
| TFormField\<T\> | lib/src/widgets/t_form_field.dart | Composite widget: label + description + field builder + error label |
| StatelessTFormField | lib/src/widgets/t_form_field.dart | Layout-only form field with disabled/read-only state handling |
| TFormFieldBuilder\<T\> | lib/src/widgets/t_form_field_builder.dart | ValueListenableBuilder wrapper for reactive field rebuilds |
| TErrorLabel | lib/src/widgets/t_error_label.dart | Animated error text with expand/collapse |
| VerticalShrink | lib/src/widgets/vertical_shrink.dart | Coordinated size + fade transition for show/hide |

## Data Flow

```
TFormConfig<DTO> (form definition)
  └── Map<Enum, TFormFieldConfig> (field registry)
        └── TFormFieldConfig<T> extends TNotifier<TFormFieldState<T>>
              ├── owns: ShadCN controllers + FocusNode
              ├── mutators: updateValue(), updateValues(), silentReset(), etc.
              └── notifies: TFormFieldBuilder / TFormField (widget layer)
                    └── builder callback renders field UI
```

**Validation flow:** `TFormConfig.isValid` → iterates `formFieldConfigs.values` → calls `TFormFieldConfig.isValid` on each enabled+visible field → dispatches to `valueValidator` or `valuesValidator` based on `TFieldType` → updates `errorText` in state → `TErrorLabel` animates in/out.

## Dependency Graph

```
TFormConfig<DTO>
  └── TFormFieldConfig

TFormFieldConfig<T>
  ├── TNotifier (turbo_notifiers)
  ├── Turbolytics (turbolytics) — logging mixin
  ├── TFormFieldState<T> (Equatable)
  ├── TFieldType
  ├── ShadTextEditingController (shadcn_ui)
  ├── ShadSelectController<T> (shadcn_ui)
  ├── ShadTimePickerController (shadcn_ui)
  └── ShadSliderController (shadcn_ui)

TFormField<T> (widget)
  ├── TFormFieldConfig<T>
  ├── TFormFieldBuilder<T>
  ├── StatelessTFormField
  ├── TErrorLabel
  └── TurboFormsDefaults

TErrorLabel
  └── VerticalShrink
```

## Configuration

No environment variables, build configurations, or feature flags. Package is configured via `pubspec.yaml` and consumed as a dependency.

## Testing Structure

No test directory present.
