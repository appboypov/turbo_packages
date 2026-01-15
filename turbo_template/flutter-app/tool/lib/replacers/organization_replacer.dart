import 'dart:io';

import '../utils/file_utils.dart';

/// Replaces the organization domain throughout the project.
///
/// Current value: `app.apewpew`
/// Target files: build.gradle.kts, project.pbxproj, AppInfo.xcconfig, Runner.rc
class OrganizationReplacer {
  static const oldValue = 'app.apewpew';

  /// File patterns to search for organization replacements.
  static const filePatterns = [
    'build.gradle.kts',
    'build.gradle',
    'project.pbxproj',
    'Configs/AppInfo.xcconfig',
    'runner/Runner.rc',
  ];

  /// Replaces the old organization domain with the new value.
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
