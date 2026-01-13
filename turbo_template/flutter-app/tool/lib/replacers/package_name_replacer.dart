import 'dart:io';

import '../utils/file_utils.dart';

/// Replaces the package name (snake_case) throughout the project.
///
/// Current value: `turbo_flutter_template`
/// Target files: pubspec.yaml, *.dart imports, Info.plist, AppInfo.xcconfig, etc.
class PackageNameReplacer {
  static const oldValue = 'turbo_flutter_template';

  /// File patterns to search for package name replacements.
  static const filePatterns = [
    '*.dart',
    'pubspec.yaml',
    'Runner/Info.plist',
    'Configs/AppInfo.xcconfig',
    'runner/Runner.rc',
    'runner/main.cpp',
    'AndroidManifest.xml',
  ];

  /// Replaces the old package name with the new value.
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
