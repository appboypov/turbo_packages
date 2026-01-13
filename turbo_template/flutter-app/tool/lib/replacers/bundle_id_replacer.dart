import 'dart:io';

import '../utils/file_utils.dart';

/// Replaces the bundle ID suffix (camelCase) throughout the project.
///
/// Current value: `turboFlutterTemplate`
/// Target files: project.pbxproj, AppInfo.xcconfig, firebase_options.dart, etc.
class BundleIdReplacer {
  static const oldValue = 'turboFlutterTemplate';

  /// File patterns to search for bundle ID replacements.
  static const filePatterns = [
    'project.pbxproj',
    'Configs/AppInfo.xcconfig',
    'firebase_options.dart',
    'GoogleService-Info.plist',
  ];

  /// Replaces the old bundle ID suffix with the new value.
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
