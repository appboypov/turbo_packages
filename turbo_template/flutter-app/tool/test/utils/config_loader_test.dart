import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:test/test.dart';
import 'package:tool/utils/config_loader.dart';

void main() {
  group('ConfigLoader', () {
    late Directory tempDir;

    setUp(() async {
      tempDir = await Directory.systemTemp.createTemp('config_loader_test_');
    });

    tearDown(() async {
      if (await tempDir.exists()) {
        await tempDir.delete(recursive: true);
      }
    });

    group('load', () {
      test('returns null when config file does not exist', () async {
        final result = await ConfigLoader.load(tempDir);
        expect(result, isNull);
      });

      test('loads all values from config file', () async {
        final configFile = File(p.join(tempDir.path, 'template.yaml'));
        await configFile.writeAsString('''
name: my_awesome_app
organization: com.mycompany
description: My awesome application.
''');

        final result = await ConfigLoader.load(tempDir);

        expect(result, isNotNull);
        expect(result!['name'], equals('my_awesome_app'));
        expect(result['organization'], equals('com.mycompany'));
        expect(result['description'], equals('My awesome application.'));
      });

      test('handles partial config file', () async {
        final configFile = File(p.join(tempDir.path, 'template.yaml'));
        await configFile.writeAsString('''
name: partial_app
''');

        final result = await ConfigLoader.load(tempDir);

        expect(result, isNotNull);
        expect(result!['name'], equals('partial_app'));
        expect(result['organization'], isNull);
        expect(result['description'], isNull);
      });

      test('handles empty config file', () async {
        final configFile = File(p.join(tempDir.path, 'template.yaml'));
        await configFile.writeAsString('');

        final result = await ConfigLoader.load(tempDir);

        expect(result, isNull);
      });

      test('handles config with comments', () async {
        final configFile = File(p.join(tempDir.path, 'template.yaml'));
        await configFile.writeAsString('''
# Template Configuration
# Edit these values and run: make init

name: commented_app          # Package name (snake_case)
organization: io.example     # Organization domain
description: App with comments.   # App description
''');

        final result = await ConfigLoader.load(tempDir);

        expect(result, isNotNull);
        expect(result!['name'], equals('commented_app'));
        expect(result['organization'], equals('io.example'));
        expect(result['description'], equals('App with comments.'));
      });
    });

    group('merge', () {
      test('CLI arguments override config file values', () {
        final fileConfig = {
          'name': 'file_name',
          'organization': 'file.org',
          'description': 'File description.',
        };

        final result = ConfigLoader.merge(
          fileConfig: fileConfig,
          cliName: 'cli_name',
          cliOrg: 'cli.org',
          cliDescription: 'CLI description.',
        );

        expect(result['name'], equals('cli_name'));
        expect(result['organization'], equals('cli.org'));
        expect(result['description'], equals('CLI description.'));
      });

      test('uses config values when CLI args are null', () {
        final fileConfig = {
          'name': 'file_name',
          'organization': 'file.org',
          'description': 'File description.',
        };

        final result = ConfigLoader.merge(fileConfig: fileConfig);

        expect(result['name'], equals('file_name'));
        expect(result['organization'], equals('file.org'));
        expect(result['description'], equals('File description.'));
      });

      test('partial CLI override', () {
        final fileConfig = {
          'name': 'file_name',
          'organization': 'file.org',
          'description': 'File description.',
        };

        final result = ConfigLoader.merge(
          fileConfig: fileConfig,
          cliName: 'cli_name',
        );

        expect(result['name'], equals('cli_name'));
        expect(result['organization'], equals('file.org'));
        expect(result['description'], equals('File description.'));
      });

      test('uses default description when both sources are null', () {
        final result = ConfigLoader.merge(
          cliName: 'my_app',
          cliOrg: 'com.example',
        );

        expect(result['name'], equals('my_app'));
        expect(result['organization'], equals('com.example'));
        expect(result['description'], equals('A Flutter application.'));
      });

      test('returns null for name/org when no sources available', () {
        final result = ConfigLoader.merge();

        expect(result['name'], isNull);
        expect(result['organization'], isNull);
        expect(result['description'], equals('A Flutter application.'));
      });

      test('handles null config file gracefully', () {
        final result = ConfigLoader.merge(
          fileConfig: null,
          cliName: 'cli_only_app',
          cliOrg: 'cli.only',
        );

        expect(result['name'], equals('cli_only_app'));
        expect(result['organization'], equals('cli.only'));
      });
    });
  });
}
