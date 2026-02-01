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
    ..addOption(
      'file',
      help: 'Sync only a specific file (must be in sync_upwards whitelist)',
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
      'all',
      abbr: 'a',
      help: 'Sync all whitelisted files (not just changed ones)',
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
    final syncAll = results['all'] as bool;
    final templateOverride = results['template'] as String?;
    final specificFile = results['file'] as String?;

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

    // Validate sync_upwards whitelist
    if (projectConfig.syncUpwards.isEmpty) {
      stderr.writeln(
          'Error: sync_upwards is empty in ${ConfigReader.configFileName}');
      stderr.writeln('Add paths to sync_upwards to enable upstream sync.');
      exit(1);
    }

    // Determine template directory
    final templatePath = templateOverride ?? _findTemplatePath(projectRoot);
    if (templatePath == null) {
      stderr.writeln('Error: Could not determine template path.');
      stderr.writeln('Use --template <path> to specify the template location.');
      exit(1);
    }

    final templateDir = Directory(
      p.isAbsolute(templatePath)
          ? templatePath
          : p.join(projectRoot.path, templatePath),
    );

    if (!await templateDir.exists()) {
      stderr
          .writeln('Error: Template directory not found: ${templateDir.path}');
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

    // Verify project is a git repository
    if (!await GitUtils.isGitRepository(projectRoot)) {
      stderr.writeln('Error: Project directory is not a git repository.');
      exit(1);
    }

    // Get git information
    final projectHead = await GitUtils.getCurrentHead(projectRoot);
    if (projectHead == null) {
      stderr.writeln('Error: Could not get project HEAD commit.');
      exit(1);
    }

    final lastSync = projectConfig.lastCommitSync;

    // Get changed files in project
    List<String> changedFiles;
    if (syncAll) {
      // Sync all tracked files
      changedFiles = await GitUtils.getChangedFiles(projectRoot);
    } else {
      changedFiles = await GitUtils.getChangedFiles(
        projectRoot,
        fromCommit: lastSync,
        toCommit: projectHead,
      );
    }

    // Filter to only whitelisted files
    final whitelistedFiles = _filterWhitelistedFiles(
      changedFiles,
      projectConfig.syncUpwards,
    );

    // Further filter by specific file if requested
    List<String> filesToSync;
    if (specificFile != null) {
      if (!_isWhitelisted(specificFile, projectConfig.syncUpwards)) {
        stderr.writeln(
            'Error: File "$specificFile" is not in sync_upwards whitelist.');
        stderr.writeln('Allowed paths:');
        for (final path in projectConfig.syncUpwards) {
          stderr.writeln('  - $path');
        }
        exit(1);
      }
      filesToSync = [specificFile];
    } else {
      filesToSync = whitelistedFiles;
    }

    // Build replacement map (reverse: project values → template defaults)
    final replacements =
        SyncUtils.buildReplacementMap(projectConfig, templateConfig);

    // Display sync information
    stdout.writeln('Sync to template (upstream):');
    stdout.writeln('  Project:  ${projectRoot.path}');
    stdout.writeln('  Template: ${templateDir.path}');
    stdout.writeln('');
    stdout.writeln('  Whitelist: ${projectConfig.syncUpwards.length} patterns');
    if (isVerbose) {
      for (final pattern in projectConfig.syncUpwards) {
        stdout.writeln('    - $pattern');
      }
    }
    stdout.writeln('');

    if (lastSync != null && !syncAll) {
      final shortLastSync =
          await GitUtils.getShortHash(projectRoot, lastSync) ?? lastSync;
      final shortHead =
          await GitUtils.getShortHash(projectRoot, projectHead) ?? projectHead;
      final commitCount = await GitUtils.getCommitCount(
        projectRoot,
        fromCommit: lastSync,
        toCommit: projectHead,
      );
      stdout.writeln('  Last sync: $shortLastSync');
      stdout.writeln('  Current:   $shortHead');
      stdout.writeln('  Commits:   $commitCount new commits');
    } else if (syncAll) {
      stdout.writeln('  Syncing all whitelisted files');
    } else {
      stdout.writeln('  First sync (checking all whitelisted files)');
    }

    stdout.writeln(
        '  Files:     ${filesToSync.length} whitelisted files to sync');
    stdout.writeln('');

    if (filesToSync.isEmpty) {
      stdout.writeln('No whitelisted files to sync.');
      exit(0);
    }

    // Show files that will be synced
    if (isVerbose || isDryRun) {
      stdout.writeln('Files to sync to template:');
      for (final file in filesToSync) {
        stdout.writeln('  $file');
      }
      stdout.writeln('');
    }

    // Confirm with user
    if (!isDryRun && !isForce) {
      stdout.writeln(
          'WARNING: This will overwrite files in the template directory.');
      stdout.writeln(
          'Project-specific values will be reverted to template defaults.');
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
    stdout.writeln('Syncing files to template...');
    var filesSynced = 0;
    var filesSkipped = 0;

    for (final relativePath in filesToSync) {
      final sourceFile = File(p.join(projectRoot.path, relativePath));
      final destFile = File(p.join(templateDir.path, relativePath));

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

    // Update last_commit_sync in project config
    final projectUpdateSuccess = await SyncUtils.updateLastCommitSync(
      projectConfigFile,
      projectHead,
    );

    stdout.writeln('');
    stdout.writeln('Sync complete:');
    stdout.writeln('  Files synced: $filesSynced');
    stdout.writeln('  Files skipped: $filesSkipped');

    if (projectUpdateSuccess) {
      final shortHead =
          await GitUtils.getShortHash(projectRoot, projectHead) ?? projectHead;
      stdout.writeln('  last_commit_sync updated to: $shortHead');
    } else {
      stderr.writeln('  Warning: Failed to update last_commit_sync');
    }

    stdout.writeln('');
    stdout.writeln('Next steps (in template directory):');
    stdout.writeln('  1. cd ${templateDir.path}');
    stdout.writeln('  2. git diff  # Review the changes');
    stdout.writeln('  3. git add -p  # Stage changes selectively');
    stdout.writeln('  4. git commit -m "Sync from project"');
  } on FormatException catch (e) {
    stderr.writeln('Error: ${e.message}');
    _printUsage(parser);
    exit(1);
  }
}

/// Tries to find the template path relative to the project.
String? _findTemplatePath(Directory projectRoot) {
  // Check if we're inside the template already
  final configFile =
      File(p.join(projectRoot.path, ConfigReader.configFileName));
  if (configFile.existsSync()) {
    // Check if parent has the same config (we might be in flutter-app subdirectory)
    final parentConfig =
        File(p.join(projectRoot.parent.path, ConfigReader.configFileName));
    if (parentConfig.existsSync()) {
      return projectRoot.parent.path;
    }
  }

  // Common locations
  final possiblePaths = [
    p.join(projectRoot.parent.path, 'turbo_template'),
    p.join(projectRoot.path, '..', 'turbo_template'),
  ];

  for (final path in possiblePaths) {
    if (Directory(path).existsSync()) {
      final config = File(p.join(path, ConfigReader.configFileName));
      if (config.existsSync()) {
        return path;
      }
    }
  }

  return null;
}

/// Filters files to only include those matching the whitelist patterns.
List<String> _filterWhitelistedFiles(
    List<String> files, List<String> whitelist) {
  return files.where((file) => _isWhitelisted(file, whitelist)).toList();
}

/// Checks if a file matches any whitelist pattern.
bool _isWhitelisted(String file, List<String> whitelist) {
  for (final pattern in whitelist) {
    if (_matchesPattern(file, pattern)) {
      return true;
    }
  }
  return false;
}

/// Checks if a file path matches a whitelist pattern.
///
/// Supports:
/// - Exact match: 'pubspec.yaml'
/// - Directory match: 'lib/core/' (matches all files under lib/core/)
/// - Glob-like patterns: 'lib/**/*.dart' (simple implementation)
bool _matchesPattern(String filePath, String pattern) {
  // Normalize paths
  final normalizedFile = filePath.replaceAll('\\', '/');
  final normalizedPattern = pattern.replaceAll('\\', '/');

  // Remove trailing slash for consistency
  final cleanPattern = normalizedPattern.endsWith('/')
      ? normalizedPattern.substring(0, normalizedPattern.length - 1)
      : normalizedPattern;

  // Exact match
  if (normalizedFile == cleanPattern) {
    return true;
  }

  // Directory match (pattern is a directory prefix)
  if (normalizedFile.startsWith('$cleanPattern/')) {
    return true;
  }

  // Simple glob support
  if (cleanPattern.contains('**')) {
    // Convert glob to regex
    final regexPattern = cleanPattern
        .replaceAll('.', r'\.')
        .replaceAll('**/', '.*')
        .replaceAll('**', '.*')
        .replaceAll('*', '[^/]*');
    final regex = RegExp('^$regexPattern\$');
    return regex.hasMatch(normalizedFile);
  }

  // Single star wildcard
  if (cleanPattern.contains('*')) {
    final regexPattern =
        cleanPattern.replaceAll('.', r'\.').replaceAll('*', '[^/]*');
    final regex = RegExp('^$regexPattern\$');
    return regex.hasMatch(normalizedFile);
  }

  return false;
}

void _printUsage(ArgParser parser) {
  stdout.writeln('Usage: dart run scripts/sync_to_template.dart [options]');
  stdout.writeln('');
  stdout.writeln(
      'Syncs whitelisted files from your project back to the template.');
  stdout.writeln('Project-specific values are reverted to template defaults.');
  stdout.writeln('');
  stdout.writeln('Only files listed in sync_upwards are allowed to be synced.');
  stdout.writeln('');
  stdout.writeln('Options:');
  stdout.writeln(parser.usage);
  stdout.writeln('');
  stdout.writeln('Examples:');
  stdout.writeln('  # Preview what would be synced');
  stdout.writeln('  dart run scripts/sync_to_template.dart --dry-run');
  stdout.writeln('');
  stdout.writeln('  # Sync all whitelisted files (not just changed ones)');
  stdout.writeln('  dart run scripts/sync_to_template.dart --all');
  stdout.writeln('');
  stdout.writeln('  # Sync a specific file');
  stdout.writeln(
      '  dart run scripts/sync_to_template.dart --file lib/core/utils/helpers.dart');
  stdout.writeln('');
  stdout.writeln('  # Sync to a specific template location');
  stdout.writeln(
      '  dart run scripts/sync_to_template.dart --template ../turbo_template');
}
