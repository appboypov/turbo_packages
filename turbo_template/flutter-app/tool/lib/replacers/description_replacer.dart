import 'dart:io';

import '../utils/file_utils.dart';

/// Replaces the app description throughout the project.
///
/// Current value: `A new Flutter project.`
/// Target files: pubspec.yaml, manifest.json, index.html
class DescriptionReplacer {
  static const oldValue = 'A new Flutter project.';

  /// File patterns to search for description replacements.
  static const filePatterns = [
    'pubspec.yaml',
    'manifest.json',
    'index.html',
  ];

  /// Replaces the old description with the new value.
  ///
  /// Returns the number of files modified.
  static Future<int> replace(Directory projectRoot, String newValue) async {
    if (newValue == oldValue) return 0;

    final files = await FileUtils.findFiles(projectRoot, filePatterns);
    var modifiedCount = 0;

    for (final file in files) {
      final modified = await FileUtils.replaceInFile(file, oldValue, newValue);
      if (modified) modifiedCount++;
    }

    return modifiedCount;
  }

  /// Performs a dry run, returning files that would be modified with line details.
  static Future<List<FileChangeInfo>> dryRun(
    Directory projectRoot,
    String newValue,
  ) async {
    final files = await FileUtils.findFiles(projectRoot, filePatterns);
    final changes = <FileChangeInfo>[];

    for (final file in files) {
      final info = await FileUtils.getFileChangeInfo(file, oldValue, newValue);
      if (info != null) {
        changes.add(info);
      }
    }

    return changes;
  }
}
