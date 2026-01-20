import 'dart:io';

import 'package:path/path.dart' as p;

import 'config_reader.dart';

/// Utilities for sync operations.
class SyncUtils {
  /// Updates the last_commit_sync value in the config file.
  static Future<bool> updateLastCommitSync(
    File configFile,
    String commitHash,
  ) async {
    try {
      final content = await configFile.readAsString();

      // Simple regex replacement for the last_commit_sync value
      final updated = content.replaceAllMapped(
        RegExp(r'(last_commit_sync:\s*)(\S+|null)'),
        (match) => '${match[1]}$commitHash',
      );

      await configFile.writeAsString(updated);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Copies a file from source to destination, applying value replacements.
  static Future<bool> copyFileWithReplacements(
    File source,
    File destination,
    Map<String, String> replacements,
  ) async {
    try {
      // Ensure destination directory exists
      final destDir = destination.parent;
      if (!await destDir.exists()) {
        await destDir.create(recursive: true);
      }

      // Check if file is binary
      if (_isBinaryFile(source.path)) {
        // Copy binary file as-is
        await source.copy(destination.path);
        return true;
      }

      // Read and replace text content
      var content = await source.readAsString();

      for (final entry in replacements.entries) {
        if (entry.key != entry.value) {
          content = content.replaceAll(entry.key, entry.value);
        }
      }

      await destination.writeAsString(content);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Builds a replacement map from template defaults to project values.
  ///
  /// [templateConfig] contains the default values from the template.
  /// [projectConfig] contains the project-specific values.
  static Map<String, String> buildReplacementMap(
    TemplateConfig templateConfig,
    TemplateConfig projectConfig,
  ) {
    return {
      // Package name variants
      templateConfig.packageName: projectConfig.packageName,
      templateConfig.camelCasePackageName: projectConfig.camelCasePackageName,
      templateConfig.pascalCasePackageName: projectConfig.pascalCasePackageName,

      // Organization
      templateConfig.organization: projectConfig.organization,

      // App name and display name
      templateConfig.appName: projectConfig.appName,
      templateConfig.displayName: projectConfig.displayName,

      // Description
      templateConfig.description: projectConfig.description,

      // URLs
      templateConfig.privacyPolicyUrl: projectConfig.privacyPolicyUrl,
      templateConfig.termsOfServiceUrl: projectConfig.termsOfServiceUrl,
      templateConfig.supportUrl: projectConfig.supportUrl,

      // Firebase project IDs
      templateConfig.prodProjectId: projectConfig.prodProjectId,
      templateConfig.stagingProjectId: projectConfig.stagingProjectId,
    };
  }

  /// Checks if a file should be excluded from sync.
  static bool shouldExcludeFile(String relativePath) {
    // Exclude config file itself
    if (relativePath == ConfigReader.configFileName) return true;

    // Exclude git-related files
    if (relativePath.startsWith('.git/')) return true;
    if (relativePath == '.gitignore') return true;

    // Exclude build artifacts
    if (relativePath.startsWith('build/')) return true;
    if (relativePath.startsWith('.dart_tool/')) return true;

    // Exclude IDE files
    if (relativePath.startsWith('.idea/')) return true;
    if (relativePath.startsWith('.vscode/')) return true;

    // Exclude scripts directory
    if (relativePath.startsWith('scripts/')) return true;

    // Exclude lock files
    if (relativePath.endsWith('.lock')) return true;
    if (relativePath.endsWith('pubspec.lock')) return true;

    return false;
  }

  /// Checks if a file is binary based on extension.
  static bool _isBinaryFile(String filePath) {
    final ext = p.extension(filePath).toLowerCase();
    const binaryExtensions = {
      '.png',
      '.jpg',
      '.jpeg',
      '.gif',
      '.ico',
      '.ttf',
      '.otf',
      '.woff',
      '.woff2',
      '.pdf',
      '.jar',
      '.aar',
      '.apk',
      '.ipa',
      '.aab',
      '.zip',
      '.tar',
      '.gz',
      '.key',
      '.p12',
      '.keystore',
      '.jks',
      '.mobileprovision',
      '.provisionprofile',
    };
    return binaryExtensions.contains(ext);
  }
}
