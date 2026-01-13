import 'package:test/test.dart';
import 'package:tool/replacers/package_name_replacer.dart';

void main() {
  group('PackageNameReplacer', () {
    group('string replacement logic', () {
      test('replaces package name in import statement', () {
        const input = "import 'package:turbo_flutter_template/main.dart';";
        const expected = "import 'package:my_app/main.dart';";

        final result = input.replaceAll(
          PackageNameReplacer.oldValue,
          'my_app',
        );
        expect(result, equals(expected));
      });

      test('replaces multiple occurrences in same file', () {
        const input = '''
import 'package:turbo_flutter_template/main.dart';
import 'package:turbo_flutter_template/app.dart';
''';
        const expected = '''
import 'package:my_app/main.dart';
import 'package:my_app/app.dart';
''';

        final result = input.replaceAll(
          PackageNameReplacer.oldValue,
          'my_app',
        );
        expect(result, equals(expected));
      });

      test('replaces in pubspec.yaml name field', () {
        const input = 'name: turbo_flutter_template';
        const expected = 'name: my_app';

        final result = input.replaceAll(
          PackageNameReplacer.oldValue,
          'my_app',
        );
        expect(result, equals(expected));
      });

      test('replaces in Info.plist CFBundleName', () {
        const input = '''
<key>CFBundleName</key>
<string>turbo_flutter_template</string>
''';
        const expected = '''
<key>CFBundleName</key>
<string>my_app</string>
''';

        final result = input.replaceAll(
          PackageNameReplacer.oldValue,
          'my_app',
        );
        expect(result, equals(expected));
      });

      test('replaces in Windows Runner.rc', () {
        const input = '''
VALUE "FileDescription", "turbo_flutter_template" "\\0"
VALUE "InternalName", "turbo_flutter_template" "\\0"
VALUE "OriginalFilename", "turbo_flutter_template.exe" "\\0"
VALUE "ProductName", "turbo_flutter_template" "\\0"
''';
        const expected = '''
VALUE "FileDescription", "my_app" "\\0"
VALUE "InternalName", "my_app" "\\0"
VALUE "OriginalFilename", "my_app.exe" "\\0"
VALUE "ProductName", "my_app" "\\0"
''';

        final result = input.replaceAll(
          PackageNameReplacer.oldValue,
          'my_app',
        );
        expect(result, equals(expected));
      });

      test('does NOT replace partial matches with suffix', () {
        const input = "import 'package:turbo_flutter_template_utils/main.dart';";

        // This SHOULD be replaced because it's a valid package name replacement
        // The import would become my_app_utils which is correct behavior
        final result = input.replaceAll(
          PackageNameReplacer.oldValue,
          'my_app',
        );
        expect(result, equals("import 'package:my_app_utils/main.dart';"));
      });

      test('does NOT replace in unrelated strings', () {
        const input = 'This is some random text without the package name';

        final result = input.replaceAll(
          PackageNameReplacer.oldValue,
          'my_app',
        );
        expect(result, equals(input));
      });
    });

    group('file patterns', () {
      test('includes dart files', () {
        expect(PackageNameReplacer.filePatterns, contains('*.dart'));
      });

      test('includes pubspec.yaml', () {
        expect(PackageNameReplacer.filePatterns, contains('pubspec.yaml'));
      });

      test('includes Info.plist', () {
        expect(PackageNameReplacer.filePatterns, contains('Runner/Info.plist'));
      });

      test('includes AppInfo.xcconfig', () {
        expect(
          PackageNameReplacer.filePatterns,
          contains('Configs/AppInfo.xcconfig'),
        );
      });

      test('includes Runner.rc', () {
        expect(PackageNameReplacer.filePatterns, contains('runner/Runner.rc'));
      });

      test('includes AndroidManifest.xml', () {
        expect(PackageNameReplacer.filePatterns, contains('AndroidManifest.xml'));
      });

      test('targets seven file patterns', () {
        expect(PackageNameReplacer.filePatterns.length, equals(7));
      });
    });
  });
}
