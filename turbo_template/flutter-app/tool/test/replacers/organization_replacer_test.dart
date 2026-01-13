import 'package:test/test.dart';
import 'package:tool/replacers/organization_replacer.dart';

void main() {
  group('OrganizationReplacer', () {
    group('string replacement logic', () {
      test('replaces organization in build.gradle.kts namespace', () {
        const input = 'namespace = "com.example.turbo_flutter_template"';
        const expected = 'namespace = "io.mycompany.turbo_flutter_template"';

        final result = input.replaceAll(
          OrganizationReplacer.oldValue,
          'io.mycompany',
        );
        expect(result, equals(expected));
      });

      test('replaces organization in build.gradle.kts applicationId', () {
        const input = 'applicationId = "com.example.turbo_flutter_template"';
        const expected = 'applicationId = "io.mycompany.turbo_flutter_template"';

        final result = input.replaceAll(
          OrganizationReplacer.oldValue,
          'io.mycompany',
        );
        expect(result, equals(expected));
      });

      test('replaces organization in project.pbxproj', () {
        const input =
            'PRODUCT_BUNDLE_IDENTIFIER = com.example.turboFlutterTemplate;';
        const expected =
            'PRODUCT_BUNDLE_IDENTIFIER = io.mycompany.turboFlutterTemplate;';

        final result = input.replaceAll(
          OrganizationReplacer.oldValue,
          'io.mycompany',
        );
        expect(result, equals(expected));
      });

      test('replaces organization in AppInfo.xcconfig', () {
        const input = 'PRODUCT_BUNDLE_IDENTIFIER = com.example.turboFlutterTemplate';
        const expected =
            'PRODUCT_BUNDLE_IDENTIFIER = io.mycompany.turboFlutterTemplate';

        final result = input.replaceAll(
          OrganizationReplacer.oldValue,
          'io.mycompany',
        );
        expect(result, equals(expected));
      });

      test('replaces organization in Windows Runner.rc copyright', () {
        const input =
            'VALUE "LegalCopyright", "Copyright (C) 2026 com.example. All rights reserved." "\\0"';
        const expected =
            'VALUE "LegalCopyright", "Copyright (C) 2026 io.mycompany. All rights reserved." "\\0"';

        final result = input.replaceAll(
          OrganizationReplacer.oldValue,
          'io.mycompany',
        );
        expect(result, equals(expected));
      });

      test('replaces organization in macOS AppInfo.xcconfig copyright', () {
        const input =
            'PRODUCT_COPYRIGHT = Copyright © 2026 com.example. All rights reserved.';
        const expected =
            'PRODUCT_COPYRIGHT = Copyright © 2026 io.mycompany. All rights reserved.';

        final result = input.replaceAll(
          OrganizationReplacer.oldValue,
          'io.mycompany',
        );
        expect(result, equals(expected));
      });

      test('replaces multiple occurrences', () {
        const input = '''
namespace = "com.example.turbo_flutter_template"
applicationId = "com.example.turbo_flutter_template"
''';
        const expected = '''
namespace = "io.mycompany.turbo_flutter_template"
applicationId = "io.mycompany.turbo_flutter_template"
''';

        final result = input.replaceAll(
          OrganizationReplacer.oldValue,
          'io.mycompany',
        );
        expect(result, equals(expected));
      });

      test('does NOT replace in unrelated URLs', () {
        // This test verifies behavior - currently simple replacement would affect URLs
        // but in practice, the file patterns limit where replacements happen
        const input = 'Visit https://example.com for more info';

        final result = input.replaceAll(
          OrganizationReplacer.oldValue,
          'io.mycompany',
        );
        // com.example is not in example.com, so no change
        expect(result, equals(input));
      });
    });

    group('file patterns', () {
      test('includes build.gradle.kts', () {
        expect(
          OrganizationReplacer.filePatterns,
          contains('build.gradle.kts'),
        );
      });

      test('includes build.gradle', () {
        expect(OrganizationReplacer.filePatterns, contains('build.gradle'));
      });

      test('includes project.pbxproj', () {
        expect(OrganizationReplacer.filePatterns, contains('project.pbxproj'));
      });

      test('includes AppInfo.xcconfig', () {
        expect(
          OrganizationReplacer.filePatterns,
          contains('Configs/AppInfo.xcconfig'),
        );
      });

      test('includes Runner.rc', () {
        expect(OrganizationReplacer.filePatterns, contains('runner/Runner.rc'));
      });
    });
  });
}
