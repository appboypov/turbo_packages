# Request: Integrate turbo_forms into Monorepo

## Source Input

```
currently:
  - a package exists called turbo_forms
  i mistakenly created this with wrong data - before this mono repo
should:
  - make it a folder of this mono repo and melos
  update the version
  clear the complete content of it (dont pull the github - start fresh)
  move the exact content of TFormField and TFormFieldConfig etc to it and have the
  turbo template use it
constraints:
  - do not use any of the old package logic
acceptance criteria:
  - `{{ should }}` is verified
  - `{{ constraints }}` do not happen
```

## Current Understanding

**What exists:**
- External `turbo_forms` package on pub.dev/GitHub (created before this monorepo) - to be ignored
- Form implementation currently embedded in `turbo_template/flutter-app/lib/core/ux/`:
  - `config/t_form_field_config.dart` (with part files: `t_form_field_state.dart`, `t_form_field_extensions.dart`)
  - `widgets/t_form_field.dart`
  - `widgets/t_form_field_builder.dart`
  - `enums/t_field_type.dart`
  - `abstracts/t_form_config.dart`
  - `typedefs/t_form_field_builder_def.dart`

**What needs to happen:**
1. Create fresh `turbo_forms/` folder in monorepo root
2. Add to Dart workspace in root `pubspec.yaml`
3. Move form classes from turbo_template to turbo_forms
4. Have turbo_template depend on turbo_forms
5. Start with version 0.0.1 (fresh start)

**Dependencies of current form implementation:**
- `turbo_notifiers` (TNotifier)
- `turbolytics` (logging)
- `shadcn_ui` (ShadTextEditingController, ShadSelectController, ShadTimePickerController, ShadSliderController)
- `equatable`
- Flutter SDK

## Identified Ambiguities

1. **Version number**: Start at 0.0.1 or different version?
2. **shadcn_ui dependency**: The current implementation uses shadcn_ui controllers. Should turbo_forms depend on shadcn_ui, or should we abstract this?
3. **Scope of extraction**: Extract ALL form-related code from turbo_template, or only the core classes mentioned?
4. **What about form files in turbo_template?**: There are 8+ form files in `auth/forms/` that USE the form classes - do these stay in turbo_template?

## Decisions

| # | Question | Answer | Date |
|---|----------|--------|------|
| 1 | Version number | 1.0.1 (pub.dev has 1.0.0 published, must increment) | 2026-01-22 |
| 2 | shadcn_ui dependency | Yes, turbo_forms will depend on shadcn_ui directly | 2026-01-22 |
| 3 | Extraction scope | Core classes only (TFormFieldConfig, TFormFieldState, TFieldType, TFormField, TFormFieldBuilder, TFormConfig, typedefs). App-specific forms stay in turbo_template. | 2026-01-22 |
| 4 | Cleanup approach | Delete original files from turbo_template, update all imports to use turbo_forms package | 2026-01-22 |
| 5 | Extensions approach | Create TurboFormFieldExtensions with `t` prefixed methods (tTryAsDouble, tTryAsInt, tHasDecimals, tNaked, tAsType). Create TurboFormsDefaults abstract class with static consts for all defaults. No magic numbers. | 2026-01-22 |
| 6 | Widget scope | Include TFormField and TErrorLabel widgets. Remove IconLabelDto dependency (user provides icon widgets). Replace TGap with SizedBox. Move TDurations and TSizes values to TurboFormsDefaults. | 2026-01-22 |
| 7 | Error text style | TErrorLabel requires errorTextStyle parameter (no theme dependency). User provides the style. | 2026-01-22 |
| 8 | VerticalShrink | Copy VerticalShrink to turbo_forms (not move). turbo_template keeps its own copy. | 2026-01-22 |

## Final Intent

Create a fresh `turbo_forms` package in this monorepo that extracts the form infrastructure from turbo_template:

**Package Setup:**
- Create `turbo_forms/` folder at monorepo root
- Version: 1.0.1 (pub.dev has 1.0.0)
- Add to Dart workspace in root pubspec.yaml
- Dependencies: turbo_notifiers, turbolytics, shadcn_ui, equatable, flutter

**Classes to Extract (copy, then delete from turbo_template):**
- `TFormFieldConfig` (with part files: `TFormFieldState`, extensions)
- `TFieldType` enum
- `TFormFieldBuilder` widget
- `TFormConfig` abstract class
- `TFormField` widget (simplified, no IconLabelDto)
- `TErrorLabel` widget (with required errorTextStyle parameter)
- `VerticalShrink` widget (copied, not moved)
- `ValuesValidatorDef` typedef
- `TFormFieldBuilderDef` typedef

**New Classes to Create:**
- `TurboFormsDefaults` - static consts for all defaults (durations, sizes, no magic numbers)
- `TurboFormFieldExtensions` - `t` prefixed methods (tTryAsDouble, tTryAsInt, tHasDecimals, tNaked, tAsType)

**turbo_template Changes:**
- Add turbo_forms as dependency
- Delete extracted form files
- Update all imports to use turbo_forms package
- Keep app-specific form implementations (auth/forms/)

**Constraints:**
- Do NOT use any logic from the old turbo_forms package on pub.dev
- Start completely fresh with current turbo_template implementation
