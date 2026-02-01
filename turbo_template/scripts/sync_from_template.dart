import 'dart:io';

import 'package:args/args.dart';
import 'package:path/path.dart' as p;

import 'lib/config_reader.dart';
import 'lib/git_utils.dart';
import 'lib/sync_utils.dart';

void main(List<String> arguments) async {
  final parser = ArgParser()
    ..addOption(
      'template',
      abbr: 't',
      help: 'Path to template directory (overrides config)',
    )
    ..addFlag(
      'dry-run',
      help: 'Show what would be changed without making changes',
      negatable: false,
    )
    ..addFlag(
      'force',
      abbr: 'f',
      help: 'Skip confirmation prompt',
      negatable: false,
    )
    ..addFlag(
      'verbose',
      abbr: 'v',
      help: 'Show detailed output',
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

    final isDryRun = results['dry-run'] as bool;
    final isForce = results['force'] as bool;
    final isVerbose = results['verbose'] as bool;
    final templateOverride = results['template'] as String?;

    // Find project root (current directory should have turbo_template_config.yaml)
    final projectRoot = Directory.current;
    final projectConfigFile =
        File(p.join(projectRoot.path, ConfigReader.configFileName));

    if (!await projectConfigFile.exists()) {
      stderr.writeln(
          'Error: ${ConfigReader.configFileName} not found in current directory.');
      stderr.writeln('Make sure you are running this from your project root.');
      exit(1);
    }

    // Load project configuration
    final projectConfig = await ConfigReader.load(projectRoot);
    if (projectConfig == null) {
      stderr.writeln('Error: Could not parse ${ConfigReader.configFileName}');
      exit(1);
    }

    // Determine template directory
    final templatePath = templateOverride ?? projectConfig.templatePath;
    final templateDir = Directory(
      p.isAbsolute(templatePath)
          ? templatePath
          : p.join(projectRoot.path, templatePath),
    );

    // For downstream sync, we need a reference to the original template
    // In a real scenario, this would be a separate repo or a known path
    // For this implementation, we assume the template is at a sibling path
    // or specified via --template flag

    if (!await templateDir.exists()) {
      stderr
          .writeln('Error: Template directory not found: ${templateDir.path}');
      stderr.writeln('Use --template <path> to specify the template location.');
      exit(1);
    }

    // Verify template is a git repository
    if (!await GitUtils.isGitRepository(templateDir)) {
      stderr.writeln('Error: Template directory is not a git repository.');
      exit(1);
    }

    // Load template configuration
    final templateConfigFile =
        File(p.join(templateDir.path, ConfigReader.configFileName));
    if (!await templateConfigFile.exists()) {
      stderr.writeln(
          'Error: Template config not found: ${templateConfigFile.path}');
      exit(1);
    }

    final templateConfig = await ConfigReader.load(templateDir);
    if (templateConfig == null) {
      stderr.writeln('Error: Could not parse template config.');
      exit(1);
    }

    // Get git information
    final currentHead = await GitUtils.getCurrentHead(templateDir);
    if (currentHead == null) {
      stderr.writeln('Error: Could not get template HEAD commit.');
      exit(1);
    }

    final lastSync = projectConfig.lastCommitSync;

    // Get changed files
    final changedFiles = await GitUtils.getChangedFiles(
      templateDir,
      fromCommit: lastSync,
      toCommit: currentHead,
    );

    // Filter excluded files
    final filesToSync =
        changedFiles.where((f) => !SyncUtils.shouldExcludeFile(f)).toList();

    // Build replacement map
    final replacements =
        SyncUtils.buildReplacementMap(templateConfig, projectConfig);

    // Display sync information
    stdout.writeln('Sync from template:');
    stdout.writeln('  Template: ${templateDir.path}');
    stdout.writeln('  Project:  ${projectRoot.path}');
    stdout.writeln('');

    if (lastSync != null) {
      final shortLastSync =
          await GitUtils.getShortHash(templateDir, lastSync) ?? lastSync;
      final shortHead =
          await GitUtils.getShortHash(templateDir, currentHead) ?? currentHead;
      final commitCount = await GitUtils.getCommitCount(
        templateDir,
        fromCommit: lastSync,
        toCommit: currentHead,
      );
      stdout.writeln('  Last sync: $shortLastSync');
      stdout.writeln('  Current:   $shortHead');
      stdout.writeln('  Commits:   $commitCount new commits');
    } else {
      final shortHead =
          await GitUtils.getShortHash(templateDir, currentHead) ?? currentHead;
      stdout.writeln('  First sync (copying all tracked files)');
      stdout.writeln('  Current:   $shortHead');
    }

    stdout.writeln('  Files:     ${filesToSync.length} files to sync');
    stdout.writeln('');

    if (filesToSync.isEmpty) {
      stdout.writeln('No files to sync.');
      exit(0);
    }

    // Show files that will be synced
    if (isVerbose || isDryRun) {
      stdout.writeln('Files to sync:');
      for (final file in filesToSync) {
        stdout.writeln('  $file');
      }
      stdout.writeln('');
    }

    // Confirm with user
    if (!isDryRun && !isForce) {
      stdout.write('Proceed with sync? [y/N]: ');
      final response = stdin.readLineSync()?.toLowerCase();
      if (response != 'y' && response != 'yes') {
        stdout.writeln('Aborted.');
        exit(0);
      }
      stdout.writeln('');
    }

    if (isDryRun) {
      stdout.writeln('Dry run - no files will be modified.');
      exit(0);
    }

    // Perform sync
    stdout.writeln('Syncing files...');
    var filesSynced = 0;
    var filesSkipped = 0;

    for (final relativePath in filesToSync) {
      final sourceFile = File(p.join(templateDir.path, relativePath));
      final destFile = File(p.join(projectRoot.path, relativePath));

      if (!await sourceFile.exists()) {
        if (isVerbose) {
          stdout.writeln('  Skipped (not found): $relativePath');
        }
        filesSkipped++;
        continue;
      }

      final success = await SyncUtils.copyFileWithReplacements(
        sourceFile,
        destFile,
        replacements,
      );

      if (success) {
        filesSynced++;
        if (isVerbose) {
          stdout.writeln('  Synced: $relativePath');
        }
      } else {
        filesSkipped++;
        if (isVerbose) {
          stdout.writeln('  Failed: $relativePath');
        }
      }
    }

    // Update last_commit_sync
    final updateSuccess = await SyncUtils.updateLastCommitSync(
      projectConfigFile,
      currentHead,
    );

    stdout.writeln('');
    stdout.writeln('Sync complete:');
    stdout.writeln('  Files synced: $filesSynced');
    stdout.writeln('  Files skipped: $filesSkipped');

    if (updateSuccess) {
      final shortHead =
          await GitUtils.getShortHash(templateDir, currentHead) ?? currentHead;
      stdout.writeln('  last_commit_sync updated to: $shortHead');
    } else {
      stderr.writeln('  Warning: Failed to update last_commit_sync');
    }

    stdout.writeln('');
    stdout.writeln('Next steps:');
    stdout.writeln('  1. Review the changes: git diff');
    stdout.writeln('  2. Run flutter pub get');
    stdout.writeln('  3. Run flutter analyze');
    stdout.writeln('  4. Test the application');
  } on FormatException catch (e) {
    stderr.writeln('Error: ${e.message}');
    _printUsage(parser);
    exit(1);
  }
}

void _printUsage(ArgParser parser) {
  stdout.writeln('Usage: dart run scripts/sync_from_template.dart [options]');
  stdout.writeln('');
  stdout.writeln('Syncs changed files from the template to your project.');
  stdout.writeln(
      'Template default values are replaced with your project values.');
  stdout.writeln('');
  stdout.writeln('Options:');
  stdout.writeln(parser.usage);
  stdout.writeln('');
  stdout.writeln('Examples:');
  stdout.writeln('  # Preview what would be synced');
  stdout.writeln('  dart run scripts/sync_from_template.dart --dry-run');
  stdout.writeln('');
  stdout.writeln('  # Sync with verbose output');
  stdout.writeln('  dart run scripts/sync_from_template.dart --verbose');
  stdout.writeln('');
  stdout.writeln('  # Sync from a specific template location');
  stdout.writeln(
      '  dart run scripts/sync_from_template.dart --template ../turbo_template');
}
