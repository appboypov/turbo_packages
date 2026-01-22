# turbo_forms

Type-safe form field configuration and validation for Flutter with ShadCN UI integration.

## Features

- **TFormFieldConfig**: Reactive form field configuration with built-in validation
- **TFormFieldState**: Immutable state management for form fields
- **TFieldType**: Comprehensive enum for all supported field types
- **TFormConfig**: Abstract class for building type-safe form configurations
- **Widgets**: Pre-built form field widgets with animation support

## Installation

```yaml
dependencies:
  turbo_forms:
```

## Usage

```dart
import 'package:turbo_forms/turbo_forms.dart';

// Create a form field configuration
final emailConfig = TFormFieldConfig<String>(
  id: FormFieldId.email,
  fieldType: TFieldType.textInput,
  valueValidator: (value) {
    if (value?.isEmpty ?? true) return 'Email is required';
    return null;
  },
);

// Use in a widget
TFormField<String>(
  formFieldConfig: emailConfig,
  label: Text('Email'),
  errorTextStyle: TextStyle(color: Colors.red),
  builder: (context, config, child) {
    return ShadInput(
      controller: config.textEditingController,
      onChanged: (value) => config.updateValue(value),
    );
  },
);
```

## Dependencies

- `turbo_notifiers`: For reactive state management
- `turbolytics`: For logging
- `shadcn_ui`: For UI controllers
- `equatable`: For state equality
