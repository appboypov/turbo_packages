import 'package:test/test.dart';
import 'package:tool/replacers/app_name_replacer.dart';

void main() {
  group('AppNameReplacer', () {
    group('string replacement logic', () {
      test('replaces app name in ARB file', () {
        const input = '''
{
  "@@locale": "en",
  "appName": "Turbo Template",
  "@appName": {
    "description": "The application name"
  }
}
''';
        const expected = '''
{
  "@@locale": "en",
  "appName": "My Awesome App",
  "@appName": {
    "description": "The application name"
  }
}
''';

        final result = input.replaceAll(
          AppNameReplacer.oldValue,
          'My Awesome App',
        );
        expect(result, equals(expected));
      });

      test('replaces app name in t_app_config.dart', () {
        const input = '''
class TemplateAppConfig extends TAppConfig {
  @override
  String get appName => 'Turbo Template';
}
''';
        const expected = '''
class TemplateAppConfig extends TAppConfig {
  @override
  String get appName => 'My App';
}
''';

        final result = input.replaceAll(
          AppNameReplacer.oldValue,
          'My App',
        );
        expect(result, equals(expected));
      });

      test('replaces in placeholder example', () {
        const input = '''
"welcomeToApp": "Welcome to {appName}",
"@welcomeToApp": {
  "placeholders": {
    "appName": {
      "example": "Turbo Template"
    }
  }
}
''';
        const expected = '''
"welcomeToApp": "Welcome to {appName}",
"@welcomeToApp": {
  "placeholders": {
    "appName": {
      "example": "My App"
    }
  }
}
''';

        final result = input.replaceAll(
          AppNameReplacer.oldValue,
          'My App',
        );
        expect(result, equals(expected));
      });

      test('does NOT replace partial matches', () {
        const input = 'Turbo Template Plus edition';

        final result = input.replaceAll(
          AppNameReplacer.oldValue,
          'My App',
        );
        expect(result, equals('My App Plus edition'));
      });

      test('does NOT replace case-insensitive matches', () {
        const input = 'turbo template';

        final result = input.replaceAll(
          AppNameReplacer.oldValue,
          'My App',
        );
        expect(result, equals(input));
      });

      test('does NOT affect unrelated text', () {
        const input = 'Some completely different text';

        final result = input.replaceAll(
          AppNameReplacer.oldValue,
          'My App',
        );
        expect(result, equals(input));
      });
    });

    group('file patterns', () {
      test('includes ARB files', () {
        expect(AppNameReplacer.filePatterns, contains('*.arb'));
      });

      test('includes t_app_config.dart', () {
        expect(AppNameReplacer.filePatterns, contains('t_app_config.dart'));
      });

      test('only targets two patterns', () {
        expect(AppNameReplacer.filePatterns.length, equals(2));
      });
    });
  });
}
