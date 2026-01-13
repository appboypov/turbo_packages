import 'package:test/test.dart';
import 'package:tool/replacers/description_replacer.dart';

void main() {
  group('DescriptionReplacer', () {
    group('string replacement logic', () {
      test('replaces description in pubspec.yaml', () {
        const input = '''
name: turbo_flutter_template
description: A new Flutter project.
version: 1.0.0
''';
        const expected = '''
name: turbo_flutter_template
description: My awesome app for managing tasks.
version: 1.0.0
''';

        final result = input.replaceAll(
          DescriptionReplacer.oldValue,
          'My awesome app for managing tasks.',
        );
        expect(result, equals(expected));
      });

      test('replaces description in manifest.json', () {
        const input = '''
{
    "name": "turbo_flutter_template",
    "short_name": "turbo_flutter_template",
    "start_url": ".",
    "display": "standalone",
    "background_color": "#0175C2",
    "theme_color": "#0175C2",
    "description": "A new Flutter project.",
    "orientation": "portrait-primary"
}
''';
        const expected = '''
{
    "name": "turbo_flutter_template",
    "short_name": "turbo_flutter_template",
    "start_url": ".",
    "display": "standalone",
    "background_color": "#0175C2",
    "theme_color": "#0175C2",
    "description": "My awesome app.",
    "orientation": "portrait-primary"
}
''';

        final result = input.replaceAll(
          DescriptionReplacer.oldValue,
          'My awesome app.',
        );
        expect(result, equals(expected));
      });

      test('preserves YAML structure', () {
        const input = '''
name: my_app
description: A new Flutter project.

environment:
  sdk: ^3.0.0
''';
        const expected = '''
name: my_app
description: Custom description here.

environment:
  sdk: ^3.0.0
''';

        final result = input.replaceAll(
          DescriptionReplacer.oldValue,
          'Custom description here.',
        );
        expect(result, equals(expected));
      });

      test('does NOT replace partial matches', () {
        const input = 'This is A new Flutter project. Plus more.';

        final result = input.replaceAll(
          DescriptionReplacer.oldValue,
          'Custom',
        );
        expect(result, equals('This is Custom Plus more.'));
      });

      test('does NOT affect unrelated text', () {
        const input = 'Some completely different description.';

        final result = input.replaceAll(
          DescriptionReplacer.oldValue,
          'Custom',
        );
        expect(result, equals(input));
      });

      test('handles empty new description', () {
        const input = 'description: A new Flutter project.';

        final result = input.replaceAll(
          DescriptionReplacer.oldValue,
          '',
        );
        expect(result, equals('description: '));
      });
    });

    group('file patterns', () {
      test('includes pubspec.yaml', () {
        expect(DescriptionReplacer.filePatterns, contains('pubspec.yaml'));
      });

      test('includes manifest.json', () {
        expect(DescriptionReplacer.filePatterns, contains('manifest.json'));
      });

      test('includes index.html', () {
        expect(DescriptionReplacer.filePatterns, contains('index.html'));
      });

      test('targets three files', () {
        expect(DescriptionReplacer.filePatterns.length, equals(3));
      });
    });

    group('index.html replacement', () {
      test('replaces meta description in index.html', () {
        const input =
            '<meta name="description" content="A new Flutter project.">';
        const expected =
            '<meta name="description" content="My awesome app.">';

        final result = input.replaceAll(
          DescriptionReplacer.oldValue,
          'My awesome app.',
        );
        expect(result, equals(expected));
      });
    });
  });
}
