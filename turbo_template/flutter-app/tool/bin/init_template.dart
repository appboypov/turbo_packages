import 'dart:io';

import 'package:args/args.dart';
import 'package:path/path.dart' as p;
import 'package:tool/init_template.dart';
import 'package:tool/utils/config_loader.dart';

void main(List<String> arguments) async {
  final parser = ArgParser()
    ..addOption(
      'name',
      abbr: 'n',
      help: 'Package name in snake_case (e.g., my_awesome_app)',
    )
    ..addOption(
      'org',
      abbr: 'o',
      help: 'Organization domain (e.g., com.mycompany)',
    )
    ..addOption(
      'description',
      abbr: 'd',
      help: 'App description',
    )
    ..addFlag(
      'dry-run',
      help: 'Show what would be changed without making changes',
      negatable: false,
    )
    ..addFlag(
      'help',
      abbr: 'h',
      help: 'Show usage information',
      negatable: false,
    );

  try {
    final results = parser.parse(arguments);

    if (results['help'] as bool) {
      _printUsage(parser);
      return;
    }

    // Find project root (parent of tool directory)
    final toolDir = Directory.current;
    final projectRoot = Directory(p.dirname(toolDir.path));

    if (!await _isFlutterProject(projectRoot)) {
      stderr.writeln('Error: Must be run from the tool directory');
      stderr.writeln(
          'Usage: cd flutter-app/tool && dart run tool:init_template ...');
      exit(1);
    }

    // Load config file
    final fileConfig = await ConfigLoader.load(projectRoot);

    // Get CLI arguments
    final cliName = results['name'] as String?;
    final cliOrg = results['org'] as String?;
    final cliDescription = results['description'] as String?;

    // Merge config sources (CLI > file > defaults)
    final merged = ConfigLoader.merge(
      fileConfig: fileConfig,
      cliName: cliName,
      cliOrg: cliOrg,
      cliDescription: cliDescription,
    );

    final name = merged['name'];
    final org = merged['organization'];
    final description = merged['description']!;

    // Validate required fields
    if (name == null || org == null) {
      stderr.writeln('Error: --name and --org are required');
      if (fileConfig == null) {
        stderr.writeln(
            'Tip: Create a template.yaml config file or provide CLI arguments');
      } else {
        stderr.writeln(
            'Tip: Ensure template.yaml has name and organization fields');
      }
      _printUsage(parser);
      exit(1);
    }

    final config = TemplateConfig(
      packageName: name,
      organization: org,
      description: description,
    );

    final isDryRun = results['dry-run'] as bool;
    final initializer = TemplateInitializer(projectRoot);

    if (isDryRun) {
      stdout.writeln('Dry run - showing what would be changed:\n');

      final dryRunResult = await initializer.dryRun(config);

      if (!dryRunResult.isValid) {
        stderr.writeln('Error: ${dryRunResult.error}');
        exit(1);
      }

      _printConfiguration(
        name: name,
        bundleId: config.bundleIdSuffix,
        displayName: config.displayName,
        appName: config.appName,
        org: org,
        description: description,
        fileConfig: fileConfig,
        cliName: cliName,
        cliOrg: cliOrg,
        cliDescription: cliDescription,
      );

      final replacements = {
        'Package Name': 'turbo_flutter_template → $name',
        'Bundle ID': 'turboFlutterTemplate → ${config.bundleIdSuffix}',
        'Organization': 'app.apewpew → $org',
        'Display Name': 'Turbo Flutter Template → ${config.displayName}',
        'Description': 'A new Flutter project. → $description',
        'App Name': 'Turbo Template → ${config.appName}',
      };

      for (final entry in dryRunResult.files.entries) {
        final totalLines = entry.value.fold(0, (sum, f) => sum + f.lineCount);
        stdout.writeln(
          '${entry.key} (${replacements[entry.key]}): ${entry.value.length} files, $totalLines lines',
        );
        for (final fileInfo in entry.value) {
          final lineNums = fileInfo.lines.map((l) => l.lineNumber).join(', ');
          stdout.writeln(
              '  - ${p.relative(fileInfo.filePath, from: projectRoot.path)} [L$lineNums]');
        }
      }

      stdout.writeln(
        '\nTotal: ${dryRunResult.totalFiles} files, ${dryRunResult.totalLines} lines would be modified',
      );
    } else {
      stdout.writeln('Initializing template...\n');

      _printConfiguration(
        name: name,
        bundleId: config.bundleIdSuffix,
        displayName: config.displayName,
        appName: config.appName,
        org: org,
        description: description,
        fileConfig: fileConfig,
        cliName: cliName,
        cliOrg: cliOrg,
        cliDescription: cliDescription,
      );

      final initResult = await initializer.initialize(config);

      if (!initResult.success) {
        stderr.writeln('Error: ${initResult.error}');
        exit(1);
      }

      stdout.writeln('Results:');
      for (final result in initResult.results) {
        final status = result.hasError ? '✗' : '✓';
        final detail = result.hasError
            ? result.error
            : '${result.filesModified} files modified';
        stdout.writeln('  $status ${result.name}: $detail');
      }

      stdout
          .writeln('\nTotal: ${initResult.totalFilesModified} files modified');
      stdout.writeln('\nNext steps:');
      stdout.writeln('  1. Run: make get');
      stdout.writeln('  2. Run: make analyze');
      stdout
          .writeln('  3. Run: make firebase-init (configure Firebase project)');
      stdout.writeln('  4. Run: flutter run');
      stdout.writeln('');
      stdout.writeln('Manual setup required:');
      stdout.writeln(
          '  • iOS/macOS: Update DEVELOPMENT_TEAM in Xcode project settings');
      stdout.writeln('  • Android: Create signing keys for release builds');
      stdout.writeln('  • Web: Update favicon and icons in web/icons/');
    }
  } on FormatException catch (e) {
    stderr.writeln('Error: ${e.message}');
    _printUsage(parser);
    exit(1);
  }
}

void _printConfiguration({
  required String name,
  required String bundleId,
  required String displayName,
  required String appName,
  required String org,
  required String description,
  required Map<String, String>? fileConfig,
  required String? cliName,
  required String? cliOrg,
  required String? cliDescription,
}) {
  stdout.writeln('Configuration:');
  stdout.writeln(
      '  Package name:  $name ${_source(cliName, fileConfig?['name'])}');
  stdout.writeln('  Bundle ID:     $bundleId (derived)');
  stdout.writeln('  Display name:  $displayName (derived)');
  stdout.writeln('  App name:      $appName (derived)');
  stdout.writeln(
      '  Organization:  $org ${_source(cliOrg, fileConfig?['organization'])}');
  stdout.writeln(
    '  Description:   $description ${_source(cliDescription, fileConfig?['description'])}',
  );
  stdout.writeln('');
}

String _source(String? cliValue, String? fileValue) {
  if (cliValue != null) return '(cli)';
  if (fileValue != null) return '(config)';
  return '(default)';
}

void _printUsage(ArgParser parser) {
  stdout.writeln('Usage: dart run tool:init_template [options]');
  stdout.writeln('');
  stdout.writeln('Initializes the Flutter template with your project details.');
  stdout.writeln('');
  stdout.writeln(
      'Values are loaded from template.yaml and can be overridden with CLI arguments.');
  stdout.writeln('');
  stdout.writeln('Options:');
  stdout.writeln(parser.usage);
  stdout.writeln('');
  stdout.writeln('Examples:');
  stdout.writeln('  # Use config file');
  stdout.writeln('  dart run tool:init_template');
  stdout.writeln('');
  stdout.writeln('  # Override with CLI arguments');
  stdout.writeln('  dart run tool:init_template \\');
  stdout.writeln('    --name my_awesome_app \\');
  stdout.writeln('    --org com.mycompany \\');
  stdout.writeln('    --description "My awesome Flutter app"');
}

Future<bool> _isFlutterProject(Directory dir) async {
  final pubspec = File(p.join(dir.path, 'pubspec.yaml'));
  return pubspec.exists();
}
