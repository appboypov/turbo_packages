import 'dart:io';

import 'package:args/args.dart';
import 'package:path/path.dart' as p;

import 'lib/config_reader.dart';
import 'lib/file_processor.dart';

void main(List<String> arguments) async {
  final parser = ArgParser()
    ..addFlag(
      'dry-run',
      help: 'Show what would be changed without making changes',
      negatable: false,
    )
    ..addFlag(
      'verbose',
      abbr: 'v',
      help: 'Show detailed output',
      negatable: false,
    )
    ..addFlag(
      'yes',
      abbr: 'y',
      help: 'Skip confirmation prompt',
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

    // Find template root (directory containing turbo_template_config.yaml)
    final templateRoot = await _findTemplateRoot(Directory.current);

    if (templateRoot == null) {
      stderr.writeln('Error: Could not find turbo_template_config.yaml');
      stderr.writeln(
          'Make sure you are running this script from within the template directory.');
      exit(1);
    }

    stdout.writeln('Template root: ${templateRoot.path}');
    stdout.writeln('');

    // Load configuration
    final config = await ConfigReader.load(templateRoot);

    if (config == null) {
      stderr.writeln('Error: Could not load turbo_template_config.yaml');
      exit(1);
    }

    // Build replacements map
    final replacements = _buildReplacements(config);

    final isDryRun = results['dry-run'] as bool;
    final isVerbose = results['verbose'] as bool;
    final skipConfirmation = results['yes'] as bool;

    // Show configuration
    _printConfiguration(config, replacements);

    // Confirm with user
    if (!isDryRun && !skipConfirmation) {
      stdout.write('\nProceed with initialization? [y/N]: ');
      final response = stdin.readLineSync()?.toLowerCase();
      if (response != 'y' && response != 'yes') {
        stdout.writeln('Aborted.');
        exit(0);
      }
    }

    stdout.writeln('');

    if (isDryRun) {
      stdout.writeln('Dry run - scanning for changes...\n');
    } else {
      stdout.writeln('Initializing template...\n');
    }

    // Process files
    final result = await FileProcessor.processFiles(
      templateRoot,
      replacements,
      dryRun: isDryRun,
      onProgress: isVerbose ? (msg) => stdout.writeln('  $msg') : null,
    );

    // Print results
    stdout.writeln('');
    if (isDryRun) {
      stdout.writeln('Dry run complete:');
      stdout.writeln('  Files that would be modified: ${result.filesModified}');
      stdout.writeln('  Files scanned: ${result.filesScanned}');
    } else {
      stdout.writeln('Initialization complete:');
      stdout.writeln('  Files modified: ${result.filesModified}');
      stdout.writeln('  Files scanned: ${result.filesScanned}');
    }

    if (!isDryRun && result.filesModified > 0) {
      stdout.writeln('');
      stdout.writeln('Next steps:');
      stdout.writeln('  1. cd ${config.templatePath}');
      stdout.writeln('  2. flutter pub get');
      stdout.writeln('  3. flutter analyze');
      stdout.writeln('  4. flutter run');
      stdout.writeln('');
      stdout.writeln('Manual setup required:');
      stdout.writeln(
          '  - Configure Firebase: firebase projects:list, firebase use <project>');
      stdout.writeln(
          '  - iOS/macOS: Update DEVELOPMENT_TEAM in Xcode project settings');
      stdout.writeln('  - Android: Create signing keys for release builds');
    }
  } on FormatException catch (e) {
    stderr.writeln('Error: ${e.message}');
    _printUsage(parser);
    exit(1);
  }
}

/// Builds the replacements map from config values.
Map<String, String> _buildReplacements(TemplateConfig config) {
  return {
    // Package name variants
    TemplateDefaults.packageName: config.packageName,
    TemplateDefaults.camelCasePackageName: config.camelCasePackageName,
    TemplateDefaults.pascalCasePackageName: config.pascalCasePackageName,

    // Organization
    TemplateDefaults.organization: config.organization,

    // App name and display name
    TemplateDefaults.appName: config.appName,
    TemplateDefaults.displayName: config.displayName,

    // Description
    TemplateDefaults.description: config.description,

    // URLs
    TemplateDefaults.privacyPolicyUrl: config.privacyPolicyUrl,
    TemplateDefaults.termsOfServiceUrl: config.termsOfServiceUrl,
    TemplateDefaults.supportUrl: config.supportUrl,

    // Firebase project IDs
    TemplateDefaults.prodProjectId: config.prodProjectId,
    TemplateDefaults.stagingProjectId: config.stagingProjectId,
  };
}

/// Prints the configuration that will be applied.
void _printConfiguration(
  TemplateConfig config,
  Map<String, String> replacements,
) {
  stdout.writeln('Configuration:');
  stdout.writeln(
      '  Package name:     ${TemplateDefaults.packageName} → ${config.packageName}');
  stdout.writeln(
      '  Organization:     ${TemplateDefaults.organization} → ${config.organization}');
  stdout.writeln(
      '  App name:         ${TemplateDefaults.appName} → ${config.appName}');
  stdout.writeln(
      '  Display name:     ${TemplateDefaults.displayName} → ${config.displayName}');
  stdout.writeln(
      '  Description:      ${TemplateDefaults.description} → ${config.description}');
  stdout.writeln('');
  stdout.writeln(
      '  Privacy Policy:   ${TemplateDefaults.privacyPolicyUrl} → ${config.privacyPolicyUrl}');
  stdout.writeln(
      '  Terms of Service: ${TemplateDefaults.termsOfServiceUrl} → ${config.termsOfServiceUrl}');
  stdout.writeln(
      '  Support URL:      ${TemplateDefaults.supportUrl} → ${config.supportUrl}');
  stdout.writeln('');
  stdout.writeln(
      '  Prod Firebase:    ${TemplateDefaults.prodProjectId} → ${config.prodProjectId}');
  stdout.writeln(
      '  Staging Firebase: ${TemplateDefaults.stagingProjectId} → ${config.stagingProjectId}');
}

/// Finds the template root directory by looking for turbo_template_config.yaml.
Future<Directory?> _findTemplateRoot(Directory startDir) async {
  var current = startDir;

  // Look up to 5 levels
  for (var i = 0; i < 5; i++) {
    final configFile = File(p.join(current.path, ConfigReader.configFileName));
    if (await configFile.exists()) {
      return current;
    }

    final parent = current.parent;
    if (parent.path == current.path) {
      // Reached filesystem root
      break;
    }
    current = parent;
  }

  return null;
}

void _printUsage(ArgParser parser) {
  stdout.writeln('Usage: dart run scripts/init_project.dart [options]');
  stdout.writeln('');
  stdout.writeln(
      'Initializes the turbo template with your project configuration.');
  stdout.writeln('');
  stdout.writeln('Edit turbo_template_config.yaml before running this script.');
  stdout.writeln('');
  stdout.writeln('Options:');
  stdout.writeln(parser.usage);
  stdout.writeln('');
  stdout.writeln('Examples:');
  stdout.writeln('  # Preview changes');
  stdout.writeln('  dart run scripts/init_project.dart --dry-run');
  stdout.writeln('');
  stdout.writeln('  # Apply changes with verbose output');
  stdout.writeln('  dart run scripts/init_project.dart --verbose');
  stdout.writeln('');
  stdout.writeln('  # Apply changes without confirmation');
  stdout.writeln('  dart run scripts/init_project.dart --yes');
}
