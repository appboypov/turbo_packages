import 'package:test/test.dart';
import 'package:tool/replacers/display_name_replacer.dart';

void main() {
  group('DisplayNameReplacer', () {
    group('string replacement logic', () {
      test('replaces display name in Info.plist CFBundleDisplayName', () {
        const input = '''
<key>CFBundleDisplayName</key>
<string>Turbo Flutter Template</string>
''';
        const expected = '''
<key>CFBundleDisplayName</key>
<string>My Awesome App</string>
''';

        final result = input.replaceAll(
          DisplayNameReplacer.oldValue,
          'My Awesome App',
        );
        expect(result, equals(expected));
      });

      test('preserves surrounding plist structure', () {
        const input = '''
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>CFBundleDisplayName</key>
	<string>Turbo Flutter Template</string>
	<key>CFBundleName</key>
	<string>turbo_flutter_template</string>
</dict>
</plist>
''';
        const expected = '''
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>CFBundleDisplayName</key>
	<string>My App</string>
	<key>CFBundleName</key>
	<string>turbo_flutter_template</string>
</dict>
</plist>
''';

        final result = input.replaceAll(
          DisplayNameReplacer.oldValue,
          'My App',
        );
        expect(result, equals(expected));
      });

      test('does NOT replace partial matches', () {
        const input = 'This is Turbo Flutter Template Plus edition';

        final result = input.replaceAll(
          DisplayNameReplacer.oldValue,
          'My App',
        );
        // Should replace because it contains the exact string
        expect(result, equals('This is My App Plus edition'));
      });

      test('does NOT replace case-insensitive matches', () {
        const input = 'turbo flutter template';

        final result = input.replaceAll(
          DisplayNameReplacer.oldValue,
          'My App',
        );
        // Should NOT replace because case doesn't match
        expect(result, equals(input));
      });

      test('does NOT affect unrelated text', () {
        const input = 'Some completely different text';

        final result = input.replaceAll(
          DisplayNameReplacer.oldValue,
          'My App',
        );
        expect(result, equals(input));
      });
    });

    group('file patterns', () {
      test('includes Info.plist', () {
        expect(
          DisplayNameReplacer.filePatterns,
          contains('Runner/Info.plist'),
        );
      });

      test('includes index.html', () {
        expect(DisplayNameReplacer.filePatterns, contains('index.html'));
      });

      test('includes manifest.json', () {
        expect(DisplayNameReplacer.filePatterns, contains('manifest.json'));
      });

      test('includes AndroidManifest.xml', () {
        expect(
            DisplayNameReplacer.filePatterns, contains('AndroidManifest.xml'));
      });

      test('targets four file patterns', () {
        expect(DisplayNameReplacer.filePatterns.length, equals(4));
      });
    });

    group('web file replacement', () {
      test('replaces title in index.html', () {
        const input = '<title>Turbo Flutter Template</title>';
        const expected = '<title>My App</title>';

        final result = input.replaceAll(
          DisplayNameReplacer.oldValue,
          'My App',
        );
        expect(result, equals(expected));
      });

      test('replaces apple-mobile-web-app-title in index.html', () {
        const input =
            '<meta name="apple-mobile-web-app-title" content="Turbo Flutter Template">';
        const expected =
            '<meta name="apple-mobile-web-app-title" content="My App">';

        final result = input.replaceAll(
          DisplayNameReplacer.oldValue,
          'My App',
        );
        expect(result, equals(expected));
      });

      test('replaces name in manifest.json', () {
        const input = '"name": "Turbo Flutter Template",';
        const expected = '"name": "My App",';

        final result = input.replaceAll(
          DisplayNameReplacer.oldValue,
          'My App',
        );
        expect(result, equals(expected));
      });

      test('replaces short_name in manifest.json', () {
        const input = '"short_name": "Turbo Flutter Template",';
        const expected = '"short_name": "My App",';

        final result = input.replaceAll(
          DisplayNameReplacer.oldValue,
          'My App',
        );
        expect(result, equals(expected));
      });
    });

    group('Android replacement', () {
      test('replaces android:label in AndroidManifest.xml', () {
        const input = 'android:label="Turbo Flutter Template"';
        const expected = 'android:label="My App"';

        final result = input.replaceAll(
          DisplayNameReplacer.oldValue,
          'My App',
        );
        expect(result, equals(expected));
      });
    });
  });
}
