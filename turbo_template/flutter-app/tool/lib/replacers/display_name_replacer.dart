import 'dart:io';

import '../utils/file_utils.dart';

/// Replaces the display name (Title Case) throughout the project.
///
/// Current value: `Turbo Flutter Template`
/// Target files: Info.plist, index.html, manifest.json, AndroidManifest.xml
class DisplayNameReplacer {
  static const oldValue = 'Turbo Flutter Template';

  /// File patterns to search for display name replacements.
  static const filePatterns = [
    'Runner/Info.plist',
    'index.html',
    'manifest.json',
    'AndroidManifest.xml',
  ];

  /// Replaces the old display name with the new value.
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
