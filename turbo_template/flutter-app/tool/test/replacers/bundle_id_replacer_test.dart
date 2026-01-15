import 'package:test/test.dart';
import 'package:tool/replacers/bundle_id_replacer.dart';

void main() {
  group('BundleIdReplacer', () {
    group('string replacement logic', () {
      test('replaces bundle ID in project.pbxproj', () {
        const input =
            'PRODUCT_BUNDLE_IDENTIFIER = app.apewpew.turboFlutterTemplate;';
        const expected = 'PRODUCT_BUNDLE_IDENTIFIER = app.apewpew.myApp;';

        final result = input.replaceAll(
          BundleIdReplacer.oldValue,
          'myApp',
        );
        expect(result, equals(expected));
      });

      test('replaces bundle ID with RunnerTests suffix', () {
        const input =
            'PRODUCT_BUNDLE_IDENTIFIER = app.apewpew.turboFlutterTemplate.RunnerTests;';
        const expected =
            'PRODUCT_BUNDLE_IDENTIFIER = app.apewpew.myApp.RunnerTests;';

        final result = input.replaceAll(
          BundleIdReplacer.oldValue,
          'myApp',
        );
        expect(result, equals(expected));
      });

      test('replaces in AppInfo.xcconfig', () {
        const input = 'PRODUCT_BUNDLE_IDENTIFIER = app.apewpew.turboFlutterTemplate';
        const expected = 'PRODUCT_BUNDLE_IDENTIFIER = app.apewpew.myApp';

        final result = input.replaceAll(
          BundleIdReplacer.oldValue,
          'myApp',
        );
        expect(result, equals(expected));
      });

      test('replaces in firebase_options.dart iosBundleId', () {
        const input = "iosBundleId: 'app.apewpew.turboFlutterTemplate',";
        const expected = "iosBundleId: 'app.apewpew.myApp',";

        final result = input.replaceAll(
          BundleIdReplacer.oldValue,
          'myApp',
        );
        expect(result, equals(expected));
      });

      test('replaces in GoogleService-Info.plist', () {
        const input = '''
<key>BUNDLE_ID</key>
<string>app.apewpew.turboFlutterTemplate</string>
''';
        const expected = '''
<key>BUNDLE_ID</key>
<string>app.apewpew.myApp</string>
''';

        final result = input.replaceAll(
          BundleIdReplacer.oldValue,
          'myApp',
        );
        expect(result, equals(expected));
      });

      test('replaces multiple bundle IDs in project.pbxproj', () {
        const input = '''
PRODUCT_BUNDLE_IDENTIFIER = app.apewpew.turboFlutterTemplate;
PRODUCT_BUNDLE_IDENTIFIER = app.apewpew.turboFlutterTemplate;
PRODUCT_BUNDLE_IDENTIFIER = app.apewpew.turboFlutterTemplate.RunnerTests;
''';
        const expected = '''
PRODUCT_BUNDLE_IDENTIFIER = app.apewpew.myApp;
PRODUCT_BUNDLE_IDENTIFIER = app.apewpew.myApp;
PRODUCT_BUNDLE_IDENTIFIER = app.apewpew.myApp.RunnerTests;
''';

        final result = input.replaceAll(
          BundleIdReplacer.oldValue,
          'myApp',
        );
        expect(result, equals(expected));
      });

      test('does NOT replace unrelated camelCase strings', () {
        const input = 'const myVariable = turboFlutterEngine;';

        final result = input.replaceAll(
          BundleIdReplacer.oldValue,
          'myApp',
        );
        // Should NOT change because turboFlutterEngine != turboFlutterTemplate
        expect(result, equals(input));
      });
    });

    group('file patterns', () {
      test('includes project.pbxproj', () {
        expect(BundleIdReplacer.filePatterns, contains('project.pbxproj'));
      });

      test('includes AppInfo.xcconfig', () {
        expect(
          BundleIdReplacer.filePatterns,
          contains('Configs/AppInfo.xcconfig'),
        );
      });

      test('includes firebase_options.dart', () {
        expect(
          BundleIdReplacer.filePatterns,
          contains('firebase_options.dart'),
        );
      });

      test('includes GoogleService-Info.plist', () {
        expect(
          BundleIdReplacer.filePatterns,
          contains('GoogleService-Info.plist'),
        );
      });
    });
  });
}
