# Architecture

This document describes the architecture of the `turbo_serializable` package, a minimal serialization abstraction for the turbo ecosystem.

## Overview

`turbo_serializable` provides a simplified abstraction layer for objects that need to be serialized to multiple data formats. The package focuses on core functionality: JSON serialization, validation, and optional multi-format support through builder functions.

## Design Principles

1. **Simplicity** - Minimal API surface with clear responsibilities
2. **Flexibility** - Optional format support via builder pattern
3. **Composability** - Classes can be extended and composed as needed
4. **Type Safety** - Strong typing throughout the API

## Class Hierarchy

```
TWriteable (abstract)
├── toJson() : Map<String, dynamic>
└── validate<T>() : TurboResponse<T>?

TWriteableId (abstract) extends TWriteable
└── id : String

TWriteableCustomId<T> (abstract) extends TWriteable
└── id : T

TSerializable (abstract) extends TWriteable
├── toYaml() : String
├── toMarkdown() : String
├── toXml() : String
├── yamlBuilder : String Function(Map<String, dynamic> json)?
├── markdownBuilder : String Function(Map<String, dynamic> json)?
└── xmlBuilder : String Function(Map<String, dynamic> json)?

TSerializableId (abstract) extends TWriteableCustomId
└── (same serialization methods as TSerializable)

TSerializableCustomId<T> (abstract) extends TWriteableCustomId<T>
└── (same serialization methods as TSerializable)
```

## Core Components

### TWriteable

The foundation class for all serializable objects. Provides:
- **`toJson()`** - Required method to convert object to JSON map
- **`validate<T>()`** - Optional method for data validation

This class is designed for objects that need to be written to storage systems like Firestore, where JSON is the primary format.

### TWriteableId

Extends `TWriteable` with a string-based identifier. Useful for objects that require a simple string ID.

### TWriteableCustomId<T>

Generic version of `TWriteableId` that supports typed identifiers. The type parameter `T` allows for custom ID types beyond strings.

### TSerializable

Extends `TWriteable` and adds optional multi-format serialization support:
- **`toYaml()`** - Converts to YAML string using `yamlBuilder`
- **`toMarkdown()`** - Converts to Markdown string using `markdownBuilder`
- **`toXml()`** - Converts to XML string using `xmlBuilder`

Format methods throw `UnimplementedError` if the corresponding builder is `null`.

### TSerializableId

Extends `TWriteableCustomId` and adds the same serialization methods as `TSerializable`. This is the non-generic version for dynamic ID types.

### TSerializableCustomId<T>

Generic version of `TSerializableId` that provides type-safe ID handling with serialization support.

## Serialization Pattern

The package uses a builder pattern for optional format support:

1. **Primary Format**: JSON via `toJson()` (required)
2. **Optional Formats**: YAML, Markdown, XML via builder functions

Builders receive the JSON representation and return a formatted string:

```dart
String Function(Map<String, dynamic> json)? get yamlBuilder =>
    (json) => 'name: ${json['name']}\nage: ${json['age']}';
```

This pattern allows:
- Flexible format support (implement only what you need)
- Consistent data source (always from JSON)
- Simple implementation (no complex conversion logic)

## Validation Pattern

Validation is integrated with `turbo_response`:

```dart
@override
TurboResponse<T>? validate<T>() {
  if (name.isEmpty) {
    return TurboResponse.fail(error: 'Name cannot be empty');
  }
  return null;
}
```

- Returns `null` if valid
- Returns `TurboResponse.fail` if invalid
- Type parameter allows custom error data types

## Usage Patterns

### Minimal Implementation

Only implement `toJson()`:

```dart
class User extends TSerializable {
  User({required this.name});
  final String name;

  @override
  Map<String, dynamic> toJson() => {'name': name};
}
```

### Full Implementation

Implement `toJson()` and format builders:

```dart
class User extends TSerializable {
  User({required this.name, required this.age});
  final String name;
  final int age;

  @override
  Map<String, dynamic> toJson() => {
    'name': name,
    'age': age,
  };

  @override
  String Function(Map<String, dynamic> json)? get yamlBuilder =>
      (json) => 'name: ${json['name']}\nage: ${json['age']}';
}
```

### With Validation

Add validation logic:

```dart
class User extends TSerializable {
  User({required this.name});
  final String name;

  @override
  Map<String, dynamic> toJson() => {'name': name};

  @override
  TurboResponse<T>? validate<T>() {
    if (name.isEmpty) {
      return TurboResponse.fail(error: 'Name cannot be empty');
    }
    return null;
  }
}
```

## File Structure

```
lib/
├── turbo_serializable.dart          # Main library export
└── abstracts/
    ├── t_writeable.dart             # Base writeable class
    ├── t_writeable_id.dart          # String ID writeable
    ├── t_writeable_custom_id.dart   # Typed ID writeable
    ├── t_serializable.dart          # Serializable base class
    ├── t_serializable_id.dart       # Serializable with ID (non-generic)
    └── t_serializable_custom_id.dart # Serializable with ID (generic)
```

## Dependencies

- **turbo_response** - For validation responses
- **No format libraries** - Format conversion is left to implementations

## Design Decisions

### Why Builder Pattern?

The builder pattern provides:
- **Flexibility** - Each class can implement formats as needed
- **Simplicity** - No complex configuration or automatic conversion
- **Performance** - Direct control over serialization logic
- **Clarity** - Explicit format support per class

### Why JSON as Primary Format?

JSON is:
- Universal - Supported everywhere
- Simple - Easy to understand and implement
- Compatible - Works with Firestore and most storage systems
- Flexible - Can be converted to other formats

### Why Remove Format Converters?

The previous version included format converters, parsers, and generators. These were removed to:
- **Reduce complexity** - Focus on core abstraction
- **Reduce dependencies** - Fewer external packages
- **Increase flexibility** - Let implementations choose their conversion strategy
- **Simplify maintenance** - Less code to maintain

### Why t-prefix Naming?

Classes use `T` prefix to:
- **Consistency** - Matches turbo ecosystem conventions
- **Clarity** - Clearly identifies turbo package classes
- **Namespace** - Avoids conflicts with other serialization libraries

## Extension Points

The architecture allows for extension:

1. **Custom Format Builders** - Implement any format via builder functions
2. **Custom ID Types** - Use `TWriteableCustomId<T>` for typed IDs
3. **Validation Logic** - Override `validate()` for custom rules
4. **Composition** - Combine classes as needed

## Future Considerations

Potential enhancements (not currently implemented):
- Format converter utilities (as separate package)
- Parser utilities (as separate package)
- Metadata support (if needed by ecosystem)
- Layout preservation (if needed by ecosystem)

These would be separate packages to maintain the simplicity of this core abstraction.
