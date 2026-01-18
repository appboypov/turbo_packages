# turbo_serializable

[![pub package](https://img.shields.io/pub/v/turbo_serializable.svg)](https://pub.dev/packages/turbo_serializable)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)
[![Dart 3](https://img.shields.io/badge/Dart-%3E%3D3.0.0-blue.svg)](https://dart.dev)

A minimal serialization abstraction for the turbo ecosystem with optional multi-format support (JSON, YAML, Markdown, XML).

## Features

- **Simple abstraction** - Minimal base classes for serializable objects
- **Multi-format support** - Optional YAML, Markdown, and XML serialization via builder functions
- **Validation integration** - Built-in validation using TurboResponse
- **Typed identifiers** - `TSerializableId` for objects with unique identifiers
- **Builder pattern** - Optional format builders for custom serialization logic

## Installation

```yaml
dependencies:
  turbo_serializable: ^1.0.0
```

## Quick Start

```dart
import 'package:turbo_serializable/turbo_serializable.dart';

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

  @override
  String Function(Map<String, dynamic> json)? get markdownBuilder =>
      (json) => '# ${json['name']}\n\nAge: ${json['age']}';
}

void main() {
  final user = User(name: 'Alice', age: 30);

  print(user.toJson());     // {name: Alice, age: 30}
  print(user.toYaml());     // name: Alice\nage: 30
  print(user.toMarkdown()); // # Alice\n\nAge: 30
}
```

## API Reference

### Classes

| Class                | Description                                                          |
|----------------------|----------------------------------------------------------------------|
| `TSerializable`      | Base class for serializable objects                                  |
| `TSerializableId`    | Extends TSerializable with identifier support                       |
| `TWriteable`         | Base class providing `toJson()` and `validate()` methods            |
| `TWriteableId`       | Base class for objects with string identifiers                      |
| `TWriteableCustomId` | Base class for objects with typed identifiers                       |

### TSerializable Methods

| Method                | Returns                 | Description                                                          |
|-----------------------|-------------------------|----------------------------------------------------------------------|
| `toJson()`            | `Map<String, dynamic>`  | Serialize to JSON map (required override)                            |
| `toYaml()`            | `String`                | Serialize to YAML string (throws `UnimplementedError` if `yamlBuilder` is null) |
| `toMarkdown()`        | `String`                | Serialize to Markdown string (throws `UnimplementedError` if `markdownBuilder` is null) |
| `toXml()`             | `String`                | Serialize to XML string (throws `UnimplementedError` if `xmlBuilder` is null) |
| `validate<T>()`       | `TurboResponse<T>?`     | Returns `null` if valid, `TurboResponse.fail` if invalid (optional override) |

### Builder Getters

| Getter                | Type                                           | Description                                    |
|-----------------------|------------------------------------------------|------------------------------------------------|
| `yamlBuilder`         | `String Function(Map<String, dynamic> json)?`   | Optional builder for YAML serialization        |
| `markdownBuilder`     | `String Function(Map<String, dynamic> json)?`  | Optional builder for Markdown serialization    |
| `xmlBuilder`          | `String Function(Map<String, dynamic> json)?` | Optional builder for XML serialization         |

## Examples

### Basic Serializable Object

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
}
```

### With Optional Format Builders

```dart
class Document extends TSerializable {
  Document({required this.content});

  final String content;

  @override
  Map<String, dynamic> toJson() => {'content': content};

  @override
  String Function(Map<String, dynamic> json)? get markdownBuilder =>
      (json) => json['content'] as String;
}
```

### With Identifier

```dart
class Product extends TSerializableId {
  Product({required this.id, required this.name});

  @override
  final String id;
  final String name;

  @override
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
  };
}
```

### With Custom ID Type

```dart
class CustomId {
  const CustomId(this.value);
  final int value;
}

class Document extends TSerializableId {
  Document(int idValue) : _id = CustomId(idValue);

  final CustomId _id;

  @override
  CustomId get id => _id;

  @override
  Map<String, dynamic> toJson() => {'id': _id.value};
}
```

### With Validation

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
  TurboResponse<T>? validate<T>() {
    if (name.isEmpty) {
      return TurboResponse.fail(error: 'Name cannot be empty');
    }
    if (age < 0) {
      return TurboResponse.fail(error: 'Age cannot be negative');
    }
    return null;
  }
}
```

### Partial Implementation

You can implement only `toJson()` and leave format builders as `null`. Calling `toYaml()`, `toMarkdown()`, or `toXml()` will throw `UnimplementedError`:

```dart
class SimpleModel extends TSerializable {
  SimpleModel(this.name);

  final String name;

  @override
  Map<String, dynamic> toJson() => {'name': name};

  @override
  String Function(Map<String, dynamic> json)? get yamlBuilder => null;

  @override
  String Function(Map<String, dynamic> json)? get markdownBuilder => null;

  @override
  String Function(Map<String, dynamic> json)? get xmlBuilder => null;
}
```

## Error Handling

- **Serialization methods** (`toYaml`, `toMarkdown`, `toXml`) throw `UnimplementedError` if the corresponding builder getter returns `null`
- **Validation** returns `null` if valid, or `TurboResponse.fail` if invalid

## Additional Information

- [API Documentation](https://pub.dev/documentation/turbo_serializable/latest/)
- [GitHub Repository](https://github.com/appboypov/turbo_packages/tree/main/turbo_serializable)
- [Issue Tracker](https://github.com/appboypov/turbo_packages/issues)

## License

MIT
