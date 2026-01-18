// ignore_for_file: avoid_print
import 'package:turbo_response/turbo_response.dart';
import 'package:turbo_serializable/turbo_serializable.dart';

/// Example model demonstrating a full implementation with all serialization methods.
///
/// This class shows how to implement [TSerializable] with:
/// - Custom validation logic
/// - JSON serialization
/// - YAML serialization
/// - Markdown serialization
///
/// Example usage:
/// ```dart
/// final model = FullModel(name: 'Alice', age: 30);
/// final json = model.toJson();
/// final yaml = model.toYaml();
/// final markdown = model.toMarkdown();
/// ```
class FullModel extends TSerializable {
  FullModel({
    required this.name,
    required this.age,
  });
  /// The person's name.
  final String name;

  /// The person's age.
  final int age;

  /// Validates the model data.
  ///
  /// Returns `null` if valid, or a [TurboResponse] with error details if invalid.
  /// This implementation checks that:
  /// - Name is not empty
  /// - Age is not negative
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

  /// Converts the model to a JSON map.
  @override
  Map<String, dynamic> toJson() => {
        'name': name,
        'age': age,
      };

  /// Builder function for YAML serialization.
  ///
  /// Converts the JSON representation to a YAML string.
  @override
  String Function(Map<String, dynamic> json)? get yamlBuilder =>
      (json) => 'name: ${json['name']}\nage: ${json['age']}';

  /// Builder function for Markdown serialization.
  ///
  /// Converts the JSON representation to a Markdown string.
  @override
  String Function(Map<String, dynamic> json)? get markdownBuilder =>
      (json) => '# ${json['name']}\n\nAge: ${json['age']}';

  /// Builder function for XML serialization.
  ///
  /// Returns `null` to indicate XML serialization is not supported.
  @override
  String Function(Map<String, dynamic> json)? get xmlBuilder => null;
}

/// Example model demonstrating a partial implementation with only JSON support.
///
/// This class shows how to implement [TSerializable] with minimal functionality.
/// Only [toJson] is implemented; other format builders return `null`,
/// which will cause [toYaml], [toMarkdown], and [toXml] to throw
/// [UnimplementedError] if called.
///
/// Example usage:
/// ```dart
/// final model = PartialModel('Bob');
/// final json = model.toJson(); // Works
/// // model.toYaml(); // Throws UnimplementedError
/// ```
class PartialModel extends TSerializable {
  /// Creates a partial model with the given name.
  PartialModel(this.name);

  /// The model's name.
  final String name;

  /// Converts the model to a JSON map.
  @override
  Map<String, dynamic> toJson() => {'name': name};

  /// YAML builder not implemented.
  @override
  String Function(Map<String, dynamic> json)? get yamlBuilder => null;

  /// Markdown builder not implemented.
  @override
  String Function(Map<String, dynamic> json)? get markdownBuilder => null;

  /// XML builder not implemented.
  @override
  String Function(Map<String, dynamic> json)? get xmlBuilder => null;
}

/// Example model demonstrating a full implementation with an identifier.
///
/// This class shows how to implement [TSerializableId] with:
/// - A string-based identifier
/// - JSON serialization
///
/// Example usage:
/// ```dart
/// final model = FullModelWithId(id: 'user-123', name: 'Charlie');
/// print(model.id); // 'user-123'
/// final json = model.toJson();
/// ```
class FullModelWithId extends TSerializableId {
  /// Creates a model with the given ID and name.
  FullModelWithId({
    required this.id,
    required this.name,
  });

  /// The unique identifier for this model.
  @override
  final String id;

  /// The model's name.
  final String name;

  /// Converts the model to a JSON map.
  @override
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
      };

  /// YAML builder not implemented.
  @override
  String Function(Map<String, dynamic> json)? get yamlBuilder => null;

  /// Markdown builder not implemented.
  @override
  String Function(Map<String, dynamic> json)? get markdownBuilder => null;

  /// XML builder not implemented.
  @override
  String Function(Map<String, dynamic> json)? get xmlBuilder => null;
}

/// Example of a custom ID type for use with [TSerializableId].
///
/// This demonstrates how to use non-string ID types with serializable objects.
class CustomId {
  /// Creates a custom ID with the given integer value.
  const CustomId(this.value);

  /// The integer value of this ID.
  final int value;

  /// Returns a string representation of the ID.
  @override
  String toString() => 'CustomId($value)';
}

/// Example model demonstrating the use of a custom ID type.
///
/// This class shows how to use [TSerializableId] with a non-string ID type.
/// The [id] getter returns a [CustomId] instance instead of a [String].
///
/// Example usage:
/// ```dart
/// final model = CustomIdModel(42);
/// print(model.id.value); // 42
/// final json = model.toJson();
/// ```
class CustomIdModel extends TSerializableId {
  /// Creates a model with a custom ID based on the given integer value.
  CustomIdModel(int idValue) : _id = CustomId(idValue);

  /// The internal custom ID instance.
  final CustomId _id;

  /// Returns the custom ID for this model.
  @override
  CustomId get id => _id;

  /// Converts the model to a JSON map.
  ///
  /// The custom ID is serialized as its integer value.
  @override
  Map<String, dynamic> toJson() => {'id': _id.value};

  /// YAML builder not implemented.
  @override
  String Function(Map<String, dynamic> json)? get yamlBuilder => null;

  /// Markdown builder not implemented.
  @override
  String Function(Map<String, dynamic> json)? get markdownBuilder => null;

  /// XML builder not implemented.
  @override
  String Function(Map<String, dynamic> json)? get xmlBuilder => null;
}

/// Example document model demonstrating Markdown serialization.
///
/// This class shows how to implement [TSerializable] with a custom
/// Markdown builder that returns the content directly.
///
/// Example usage:
/// ```dart
/// final doc = Document(content: '# Hello World\n\nThis is content.');
/// final markdown = doc.toMarkdown(); // Returns the content directly
/// ```
class Document extends TSerializable {
  /// Creates a document with the given content.
  Document({required this.content});

  /// The document's content.
  final String content;

  /// Converts the document to a JSON map.
  @override
  Map<String, dynamic> toJson() => {'content': content};

  /// YAML builder not implemented.
  @override
  String Function(Map<String, dynamic> json)? get yamlBuilder => null;

  /// Builder function for Markdown serialization.
  ///
  /// Returns the content directly as the Markdown representation.
  @override
  String Function(Map<String, dynamic> json)? get markdownBuilder =>
      (json) => json['content'] as String;

  /// XML builder not implemented.
  @override
  String Function(Map<String, dynamic> json)? get xmlBuilder => null;
}

/// Example document model with an identifier.
///
/// This class shows how to implement [TSerializableId] for documents
/// that need both an ID and content serialization.
///
/// Example usage:
/// ```dart
/// final doc = DocumentWithId(id: 'doc-001', content: 'Content here');
/// print(doc.id); // 'doc-001'
/// final json = doc.toJson();
/// ```
class DocumentWithId extends TSerializableId {
  /// Creates a document with the given ID and content.
  DocumentWithId({
    required this.id,
    required this.content,
  });

  /// The unique identifier for this document.
  @override
  final String id;

  /// The document's content.
  final String content;

  /// Converts the document to a JSON map.
  @override
  Map<String, dynamic> toJson() => {
        'id': id,
        'content': content,
      };

  /// YAML builder not implemented.
  @override
  String Function(Map<String, dynamic> json)? get yamlBuilder => null;

  /// Markdown builder not implemented.
  @override
  String Function(Map<String, dynamic> json)? get markdownBuilder => null;

  /// XML builder not implemented.
  @override
  String Function(Map<String, dynamic> json)? get xmlBuilder => null;
}

/// Main entry point for the turbo_serializable example.
///
/// This function runs a series of validation tests to demonstrate
/// the functionality of the turbo_serializable package, including:
/// - Full implementations with multiple serialization formats
/// - Partial implementations
/// - ID-based serialization
/// - Custom ID types
/// - Validation functionality
void main() {
  print('=== turbo_serializable Validation Script ===\n');

  // Test 1: Full implementation
  print('Test 1: Full implementation');
  final full = FullModel(name: 'Alice', age: 30);
  assert(full.validate<Object?>() == null, 'Valid model should have null validate');
  assert(full.toJson()['name'] == 'Alice', 'toJson should contain name');
  assert(full.toYaml().isNotEmpty, 'toYaml should return a string');
  assert(full.toMarkdown().isNotEmpty, 'toMarkdown should return a string');
  print('  ✓ All full model methods work correctly');

  // Test 2: Full implementation with invalid data
  print('\nTest 2: Validation with invalid data');
  final invalid = FullModel(name: '', age: 30);
  assert(invalid.validate<Object?>() is Fail, 'Invalid model should fail validation');
  print('  ✓ Validation correctly rejects empty name');

  // Test 3: Partial implementation (only toJson)
  print('\nTest 3: Partial implementation (only toJson)');
  final partial = PartialModel('Bob');
  assert(partial.validate<Object?>() == null, 'Default validate returns null');
  assert(partial.toJson()['name'] == 'Bob', 'toJson should work');
  // Without builders, these will throw UnimplementedError
  try {
    partial.toYaml();
    assert(false, 'toYaml should throw UnimplementedError');
  } catch (e) {
    assert(e is UnimplementedError, 'Should throw UnimplementedError');
  }
  print('  ✓ Partial implementation works correctly');

  // Test 4: TurboSerializableId with String ID
  print('\nTest 4: TurboSerializableId with String ID');
  final withId = FullModelWithId(id: 'user-123', name: 'Charlie');
  assert(withId.id == 'user-123', 'ID getter should work');
  assert(withId.toJson()['id'] == 'user-123', 'toJson should include id');
  print('  ✓ TurboSerializableId works with String ID');

  // Test 5: Custom ID type
  print('\nTest 5: Custom ID type');
  final customId = CustomIdModel(42);
  assert(customId.id.value == 42, 'Custom ID value should work');
  print('  ✓ Custom ID types work correctly');

  // Test 6: Type inheritance verification
  print('\nTest 6: Type inheritance verification');
  assert(full.toJson().isNotEmpty, 'FullModel inherits TSerializable methods');
  assert(
    withId.toJson().isNotEmpty,
    'TSerializableId inherits TSerializable methods',
  );
  assert(withId.id.isNotEmpty, 'TSerializableId provides typed id getter');
  print('  ✓ Type inheritance is correct');

  // Test 7: Document with markdown
  print('\nTest 7: Document with markdown');
  final doc = Document(content: '# Hello World\n\nThis is content.');
  assert(doc.toJson()['content'] == '# Hello World\n\nThis is content.', 'toJson should contain content');
  assert(
    doc.toMarkdown() == '# Hello World\n\nThis is content.',
    'toMarkdown should return content',
  );
  print('  ✓ Document works correctly');

  // Test 8: Document with ID
  print('\nTest 8: Document with ID');
  final docWithId = DocumentWithId(
    id: 'doc-001',
    content: 'Content here',
  );
  assert(docWithId.id == 'doc-001', 'ID should be set');
  assert(docWithId.toJson()['id'] == 'doc-001', 'toJson should include id');
  assert(docWithId.toJson()['content'] == 'Content here', 'toJson should include content');
  print('  ✓ Document with ID works correctly');

  print('\n=== All validations passed! ===');
}
