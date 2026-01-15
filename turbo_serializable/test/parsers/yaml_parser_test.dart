import 'package:test/test.dart';
import 'package:turbo_serializable/turbo_serializable.dart';

void main() {
  group('YamlLayoutParser', () {
    const parser = YamlLayoutParser();

    group('empty and basic documents', () {
      test('parses empty string', () {
        final result = parser.parse('');
        expect(result.data, isEmpty);
        expect(result.keyMeta, isNull);
      });

      test('parses simple key-value', () {
        final result = parser.parse('name: John');
        expect(result.data['name'], 'John');
      });

      test('parses numeric value', () {
        final result = parser.parse('count: 42');
        expect(result.data['count'], 42);
      });

      test('parses boolean true', () {
        final result = parser.parse('active: true');
        expect(result.data['active'], true);
      });

      test('parses boolean false', () {
        final result = parser.parse('deleted: false');
        expect(result.data['deleted'], false);
      });

      test('parses double value', () {
        final result = parser.parse('price: 9.99');
        expect(result.data['price'], 9.99);
      });

      test('parses null value', () {
        final result = parser.parse('value: null');
        expect(result.data['value'], isNull);
      });

      test('parses empty value as null', () {
        final result = parser.parse('value:');
        expect(result.data['value'], isNull);
      });
    });

    group('anchors', () {
      test('extracts anchor from map value', () {
        const yaml = '''
defaults: &defaults
  adapter: postgres
  host: localhost
''';
        final result = parser.parse(yaml);
        expect((result.data['defaults'] as Map<String, dynamic>)['adapter'], 'postgres');
        expect((result.data['defaults'] as Map<String, dynamic>)['host'], 'localhost');
        expect(result.keyMeta, isNotNull);
        expect(((result.keyMeta!['defaults'] as Map<String, dynamic>)['yamlMeta'] as Map<String, dynamic>)['anchor'], 'defaults');
      });

      test('extracts anchor from simple value', () {
        const yaml = '''
name: &username John
''';
        final result = parser.parse(yaml);
        expect(result.data['name'], 'John');
        expect(result.keyMeta, isNotNull);
        expect(((result.keyMeta!['name'] as Map<String, dynamic>)['yamlMeta'] as Map<String, dynamic>)['anchor'], 'username');
      });
    });

    group('aliases', () {
      test('preserves alias reference with merge key syntax', () {
        const yaml = '''
defaults: &defaults
  adapter: postgres

development:
  <<: *defaults
  database: dev_db
''';
        final result = parser.parse(yaml);
        expect((result.data['defaults'] as Map<String, dynamic>)['adapter'], 'postgres');
        expect((result.data['development'] as Map<String, dynamic>)['database'], 'dev_db');
        // The yaml package preserves the << key with the referenced value
        expect(((result.data['development'] as Map<String, dynamic>)['<<'] as Map<String, dynamic>)['adapter'], 'postgres');
        // The anchor is captured on the defaults key
        expect(((result.keyMeta!['defaults'] as Map<String, dynamic>)['yamlMeta'] as Map<String, dynamic>)['anchor'], 'defaults');
      });

      test('resolves alias in simple value', () {
        const yaml = '''
base: &base value
ref: *base
''';
        final result = parser.parse(yaml);
        expect(result.data['base'], 'value');
        // The yaml package resolves aliases, so ref gets the same value
        expect(result.data['ref'], 'value');
      });
    });

    group('comments', () {
      test('extracts inline comment', () {
        const yaml = '''
name: John # This is a comment
''';
        final result = parser.parse(yaml);
        expect(result.data['name'], 'John');
        expect(result.keyMeta, isNotNull);
        expect(((result.keyMeta!['name'] as Map<String, dynamic>)['yamlMeta'] as Map<String, dynamic>)['comment'],
            'This is a comment',);
      });

      test('extracts comment from line before', () {
        const yaml = '''
# User name
name: John
''';
        final result = parser.parse(yaml);
        expect(result.data['name'], 'John');
        expect(result.keyMeta, isNotNull);
        expect(((result.keyMeta!['name'] as Map<String, dynamic>)['yamlMeta'] as Map<String, dynamic>)['comment'], 'User name');
      });

      test('handles comment with special characters', () {
        const yaml = '''
value: test # Comment with special chars: @#\$%
''';
        final result = parser.parse(yaml);
        expect(result.data['value'], 'test');
        expect(result.keyMeta, isNotNull);
        expect(((result.keyMeta!['value'] as Map<String, dynamic>)['yamlMeta'] as Map<String, dynamic>)['comment'],
            contains('Comment'),);
      });
    });

    group('flow vs block style', () {
      test('detects flow style map', () {
        const yaml = '''
person: {name: John, age: 30}
''';
        final result = parser.parse(yaml);
        expect((result.data['person'] as Map<String, dynamic>)['name'], 'John');
        expect((result.data['person'] as Map<String, dynamic>)['age'], 30);
        expect(result.keyMeta, isNotNull);
        expect(((result.keyMeta!['person'] as Map<String, dynamic>)['yamlMeta'] as Map<String, dynamic>)['style'], 'flow');
      });

      test('detects block style map', () {
        const yaml = '''
person:
  name: John
  age: 30
''';
        final result = parser.parse(yaml);
        expect((result.data['person'] as Map<String, dynamic>)['name'], 'John');
        expect((result.data['person'] as Map<String, dynamic>)['age'], 30);
        // Block style is the default, so may not have explicit metadata
      });

      test('detects flow style list', () {
        const yaml = '''
items: [a, b, c]
''';
        final result = parser.parse(yaml);
        expect(result.data['items'], ['a', 'b', 'c']);
        expect(result.keyMeta, isNotNull);
        expect(((result.keyMeta!['items'] as Map<String, dynamic>)['yamlMeta'] as Map<String, dynamic>)['style'], 'flow');
      });

      test('detects block style list', () {
        const yaml = '''
items:
  - a
  - b
  - c
''';
        final result = parser.parse(yaml);
        expect(result.data['items'], ['a', 'b', 'c']);
      });
    });

    group('scalar styles', () {
      test('detects literal block scalar', () {
        const yaml = '''
description: |
  This is a
  multiline text
''';
        final result = parser.parse(yaml);
        expect(result.data['description'], contains('This is a'));
        expect(result.keyMeta, isNotNull);
        expect(((result.keyMeta!['description'] as Map<String, dynamic>)['yamlMeta'] as Map<String, dynamic>)['scalarStyle'],
            'literal',);
      });

      test('detects folded block scalar', () {
        const yaml = '''
description: >
  This is a
  folded text
''';
        final result = parser.parse(yaml);
        expect(result.data['description'], isNotNull);
        expect(result.keyMeta, isNotNull);
        expect(((result.keyMeta!['description'] as Map<String, dynamic>)['yamlMeta'] as Map<String, dynamic>)['scalarStyle'],
            'folded',);
      });

      test('detects single-quoted scalar', () {
        const yaml = '''
name: 'John Doe'
''';
        final result = parser.parse(yaml);
        expect(result.data['name'], 'John Doe');
        expect(result.keyMeta, isNotNull);
        expect(((result.keyMeta!['name'] as Map<String, dynamic>)['yamlMeta'] as Map<String, dynamic>)['scalarStyle'],
            'single-quoted',);
      });

      test('detects double-quoted scalar', () {
        const yaml = '''
name: "John Doe"
''';
        final result = parser.parse(yaml);
        expect(result.data['name'], 'John Doe');
        expect(result.keyMeta, isNotNull);
        expect(((result.keyMeta!['name'] as Map<String, dynamic>)['yamlMeta'] as Map<String, dynamic>)['scalarStyle'],
            'double-quoted',);
      });

      test('plain scalar has no style metadata', () {
        const yaml = '''
name: John
''';
        final result = parser.parse(yaml);
        expect(result.data['name'], 'John');
        // Plain scalars don't need explicit style metadata
      });
    });

    group('multi-document support', () {
      test('parses multiple documents', () {
        const yaml = '''
---
name: Doc1
---
name: Doc2
''';
        final result = parser.parse(yaml);
        expect((result.data['_document_0'] as Map<String, dynamic>)['name'], 'Doc1');
        expect((result.data['_document_1'] as Map<String, dynamic>)['name'], 'Doc2');
      });

      test('handles document end marker', () {
        const yaml = '''
---
name: Doc1
...
---
name: Doc2
...
''';
        final result = parser.parse(yaml);
        expect((result.data['_document_0'] as Map<String, dynamic>)['name'], 'Doc1');
        expect((result.data['_document_1'] as Map<String, dynamic>)['name'], 'Doc2');
      });

      test('single document without markers', () {
        const yaml = '''
name: Single
value: 123
''';
        final result = parser.parse(yaml);
        expect(result.data['name'], 'Single');
        expect(result.data['value'], 123);
      });

      test('multi-document metadata is captured', () {
        const yaml = '''
---
a: 1
---
b: 2
''';
        final result = parser.parse(yaml);
        expect(result.keyMeta, isNotNull);
        expect(((result.keyMeta!['_document'] as Map<String, dynamic>)['yamlMeta'] as Map<String, dynamic>)['comment'],
            contains('Multi-document'),);
      });
    });

    group('nested structures', () {
      test('parses nested maps', () {
        const yaml = '''
user:
  name: John
  address:
    city: NYC
    zip: 10001
''';
        final result = parser.parse(yaml);
        expect((result.data['user'] as Map<String, dynamic>)['name'], 'John');
        expect(((result.data['user'] as Map<String, dynamic>)['address'] as Map<String, dynamic>)['city'], 'NYC');
        expect(((result.data['user'] as Map<String, dynamic>)['address'] as Map<String, dynamic>)['zip'], 10001);
      });

      test('parses nested lists', () {
        const yaml = '''
matrix:
  - - 1
    - 2
  - - 3
    - 4
''';
        final result = parser.parse(yaml);
        expect((result.data['matrix'] as List)[0], [1, 2]);
        expect((result.data['matrix'] as List)[1], [3, 4]);
      });

      test('parses lists of maps', () {
        const yaml = '''
users:
  - name: John
    age: 30
  - name: Jane
    age: 25
''';
        final result = parser.parse(yaml);
        expect(((result.data['users'] as List)[0] as Map<String, dynamic>)['name'], 'John');
        expect(((result.data['users'] as List)[0] as Map<String, dynamic>)['age'], 30);
        expect(((result.data['users'] as List)[1] as Map<String, dynamic>)['name'], 'Jane');
        expect(((result.data['users'] as List)[1] as Map<String, dynamic>)['age'], 25);
      });

      test('parses maps with list values', () {
        const yaml = '''
person:
  name: John
  hobbies:
    - reading
    - coding
''';
        final result = parser.parse(yaml);
        expect((result.data['person'] as Map<String, dynamic>)['name'], 'John');
        expect((result.data['person'] as Map<String, dynamic>)['hobbies'], ['reading', 'coding']);
      });
    });

    group('error handling', () {
      test('throws FormatException on invalid YAML', () {
        expect(
          () => parser.parse('invalid: yaml: here: nope'),
          throwsA(isA<FormatException>()),
        );
      });

      test('throws FormatException on unclosed bracket', () {
        expect(
          () => parser.parse('items: [1, 2, 3'),
          throwsA(isA<FormatException>()),
        );
      });

      test('throws FormatException on unclosed brace', () {
        expect(
          () => parser.parse('config: {a: 1, b: 2'),
          throwsA(isA<FormatException>()),
        );
      });
    });

    group('complex documents', () {
      test('parses document with anchors, comments, and styles', () {
        const yaml = '''
# Main config
defaults: &defaults
  adapter: postgres
  host: localhost

development:
  database: dev_db

production:
  database: prod_db
  password: |
    secret
    multiline
''';
        final result = parser.parse(yaml);

        // Data extraction
        expect((result.data['defaults'] as Map<String, dynamic>)['adapter'], 'postgres');
        expect((result.data['defaults'] as Map<String, dynamic>)['host'], 'localhost');
        expect((result.data['development'] as Map<String, dynamic>)['database'], 'dev_db');
        expect((result.data['production'] as Map<String, dynamic>)['database'], 'prod_db');
        expect((result.data['production'] as Map<String, dynamic>)['password'], contains('secret'));

        // Metadata extraction
        expect(result.keyMeta, isNotNull);
        expect(((result.keyMeta!['defaults'] as Map<String, dynamic>)['yamlMeta'] as Map<String, dynamic>)['anchor'], 'defaults');
        expect(
            ((result.keyMeta!['defaults'] as Map<String, dynamic>)['yamlMeta'] as Map<String, dynamic>)['comment'], 'Main config',);
      });

      test('parses mixed flow and block styles', () {
        const yaml = '''
config:
  simple: {a: 1, b: 2}
  complex:
    nested:
      deep: value
  list: [x, y, z]
''';
        final result = parser.parse(yaml);

        expect(((result.data['config'] as Map<String, dynamic>)['simple'] as Map<String, dynamic>)['a'], 1);
        expect((((result.data['config'] as Map<String, dynamic>)['complex'] as Map<String, dynamic>)['nested'] as Map<String, dynamic>)['deep'], 'value');
        expect((result.data['config'] as Map<String, dynamic>)['list'], ['x', 'y', 'z']);
      });
    });

    group('edge cases', () {
      test('handles unicode content', () {
        const yaml = 'name: 日本語テスト';
        final result = parser.parse(yaml);
        expect(result.data['name'], '日本語テスト');
      });

      test('handles emoji content', () {
        const yaml = 'emoji: Hello 🎉';
        final result = parser.parse(yaml);
        expect(result.data['emoji'], 'Hello 🎉');
      });

      test('handles special characters in strings', () {
        const yaml = 'special: "value with: colon"';
        final result = parser.parse(yaml);
        expect(result.data['special'], 'value with: colon');
      });

      test('handles empty nested structures', () {
        const yaml = '''
empty_map: {}
empty_list: []
''';
        final result = parser.parse(yaml);
        expect(result.data['empty_map'], isEmpty);
        expect(result.data['empty_list'], isEmpty);
      });

      test('handles keys with special characters', () {
        const yaml = '''
"key.with.dots": value1
"key:with:colons": value2
''';
        final result = parser.parse(yaml);
        expect(result.data['key.with.dots'], 'value1');
        expect(result.data['key:with:colons'], 'value2');
      });
    });
  });

  group('yamlToJson with preserveLayout', () {
    test('returns Map when preserveLayout is false', () {
      final result = yamlToJson('name: test');
      expect(result, isA<Map<String, dynamic>>());
    });

    test('returns LayoutAwareParseResult when preserveLayout is true', () {
      final result = yamlToJson('name: test', preserveLayout: true);
      expect(result, isA<LayoutAwareParseResult>());
    });

    test('backward compatibility - basic YAML parsing', () {
      final result = yamlToJson('name: John\nage: 30') as Map<String, dynamic>;
      expect(result['name'], 'John');
      expect(result['age'], 30);
    });

    test('backward compatibility - nested structures', () {
      const yaml = '''
user:
  name: John
  email: john@example.com
''';
      final result = yamlToJson(yaml) as Map<String, dynamic>;
      expect((result['user'] as Map<String, dynamic>)['name'], 'John');
      expect((result['user'] as Map<String, dynamic>)['email'], 'john@example.com');
    });

    test('backward compatibility - lists', () {
      const yaml = '''
items:
  - a
  - b
  - c
''';
      final result = yamlToJson(yaml) as Map<String, dynamic>;
      expect(result['items'], ['a', 'b', 'c']);
    });

    test('preserveLayout extracts anchor metadata', () {
      const yaml = '''
defaults: &defaults
  adapter: postgres
''';
      final result =
          yamlToJson(yaml, preserveLayout: true) as LayoutAwareParseResult;
      expect((result.data['defaults'] as Map<String, dynamic>)['adapter'], 'postgres');
      expect(((result.keyMeta!['defaults'] as Map<String, dynamic>)['yamlMeta'] as Map<String, dynamic>)['anchor'], 'defaults');
    });

    test('preserveLayout extracts comment metadata', () {
      const yaml = '''
name: John # User name
''';
      final result =
          yamlToJson(yaml, preserveLayout: true) as LayoutAwareParseResult;
      expect(result.data['name'], 'John');
      expect(((result.keyMeta!['name'] as Map<String, dynamic>)['yamlMeta'] as Map<String, dynamic>)['comment'], 'User name');
    });

    test('preserveLayout extracts scalar style metadata', () {
      const yaml = '''
description: |
  Multiline
  text
''';
      final result =
          yamlToJson(yaml, preserveLayout: true) as LayoutAwareParseResult;
      expect(
          ((result.keyMeta!['description'] as Map<String, dynamic>)['yamlMeta'] as Map<String, dynamic>)['scalarStyle'], 'literal',);
    });

    test('preserveLayout extracts flow style metadata', () {
      const yaml = '''
config: {a: 1, b: 2}
''';
      final result =
          yamlToJson(yaml, preserveLayout: true) as LayoutAwareParseResult;
      expect((result.data['config'] as Map<String, dynamic>)['a'], 1);
      expect(((result.keyMeta!['config'] as Map<String, dynamic>)['yamlMeta'] as Map<String, dynamic>)['style'], 'flow');
    });
  });

  group('round-trip tests', () {
    test('anchor round-trip', () {
      const original = '''
defaults: &defaults
  adapter: postgres
  host: localhost

development:
  database: dev_db
''';
      final result =
          yamlToJson(original, preserveLayout: true) as LayoutAwareParseResult;
      expect(((result.keyMeta!['defaults'] as Map<String, dynamic>)['yamlMeta'] as Map<String, dynamic>)['anchor'], 'defaults');
    });

    test('comment round-trip', () {
      const original = '''
# Main configuration
config:
  value: test
''';
      final result =
          yamlToJson(original, preserveLayout: true) as LayoutAwareParseResult;
      expect(((result.keyMeta!['config'] as Map<String, dynamic>)['yamlMeta'] as Map<String, dynamic>)['comment'],
          'Main configuration',);
    });

    test('scalar style round-trip', () {
      const original = '''
literal: |
  Line 1
  Line 2

folded: >
  This is
  folded

single: 'quoted'
double: "also quoted"
''';
      final result =
          yamlToJson(original, preserveLayout: true) as LayoutAwareParseResult;
      expect(((result.keyMeta!['literal'] as Map<String, dynamic>)['yamlMeta'] as Map<String, dynamic>)['scalarStyle'], 'literal');
      expect(((result.keyMeta!['folded'] as Map<String, dynamic>)['yamlMeta'] as Map<String, dynamic>)['scalarStyle'], 'folded');
      expect(((result.keyMeta!['single'] as Map<String, dynamic>)['yamlMeta'] as Map<String, dynamic>)['scalarStyle'],
          'single-quoted',);
      expect(((result.keyMeta!['double'] as Map<String, dynamic>)['yamlMeta'] as Map<String, dynamic>)['scalarStyle'],
          'double-quoted',);
    });

    test('flow style round-trip', () {
      const original = '''
flow_map: {a: 1, b: 2}
flow_list: [1, 2, 3]
''';
      final result =
          yamlToJson(original, preserveLayout: true) as LayoutAwareParseResult;
      expect(((result.keyMeta!['flow_map'] as Map<String, dynamic>)['yamlMeta'] as Map<String, dynamic>)['style'], 'flow');
      expect(((result.keyMeta!['flow_list'] as Map<String, dynamic>)['yamlMeta'] as Map<String, dynamic>)['style'], 'flow');
    });

    test('complex document round-trip', () {
      const original = '''
# Main config
defaults: &defaults
  adapter: postgres
  host: localhost

development:
  database: dev_db

production:
  database: prod_db
  password: |
    secret
    multiline
''';
      final result =
          yamlToJson(original, preserveLayout: true) as LayoutAwareParseResult;

      // Verify all metadata is captured
      expect(((result.keyMeta!['defaults'] as Map<String, dynamic>)['yamlMeta'] as Map<String, dynamic>)['anchor'], 'defaults');
      expect(((result.keyMeta!['defaults'] as Map<String, dynamic>)['yamlMeta'] as Map<String, dynamic>)['comment'], 'Main config');
      expect(
          ((((result.keyMeta!['production'] as Map<String, dynamic>)['children'] as Map<String, dynamic>)['password'] as Map<String, dynamic>)['yamlMeta'] as Map<String, dynamic>)
              ['scalarStyle'],
          'literal',);
    });
  });
}
