import 'dart:io';

import 'package:path/path.dart' as p;

/// Represents a line that will be changed.
class LineChange {
  final int lineNumber;
  final String before;
  final String after;

  LineChange({
    required this.lineNumber,
    required this.before,
    required this.after,
  });
}

/// Represents changes to a single file.
class FileChangeInfo {
  final String filePath;
  final List<LineChange> lines;

  FileChangeInfo({
    required this.filePath,
    required this.lines,
  });

  int get lineCount => lines.length;
}

/// Utilities for file operations during template initialization.
class FileUtils {
  /// Finds all files matching the given patterns in the project root.
  ///
  /// [projectRoot] is the root directory to search from.
  /// [patterns] is a list of glob-like patterns (e.g., '*.dart', 'pubspec.yaml').
  static Future<List<File>> findFiles(
    Directory projectRoot,
    List<String> patterns,
  ) async {
    final files = <File>[];

    await for (final entity in projectRoot.list(recursive: true)) {
      if (entity is File) {
        final relativePath = p.relative(entity.path, from: projectRoot.path);

        // Skip hidden directories and build artifacts
        if (_shouldSkip(relativePath)) continue;

        for (final pattern in patterns) {
          if (_matchesPattern(relativePath, pattern)) {
            files.add(entity);
            break;
          }
        }
      }
    }

    return files;
  }

  /// Replaces text in a file.
  ///
  /// Returns true if any replacements were made.
  static Future<bool> replaceInFile(
    File file,
    String oldValue,
    String newValue,
  ) async {
    final content = await file.readAsString();
    if (!content.contains(oldValue)) return false;

    final updated = content.replaceAll(oldValue, newValue);
    await file.writeAsString(updated);
    return true;
  }

  /// Finds all lines in a file that contain the search text.
  ///
  /// Returns a list of [LineChange] objects showing what would change.
  static Future<List<LineChange>> findMatchingLines(
    File file,
    String oldValue,
    String newValue,
  ) async {
    final content = await file.readAsString();
    if (!content.contains(oldValue)) return [];

    final lines = content.split('\n');
    final changes = <LineChange>[];

    for (var i = 0; i < lines.length; i++) {
      final line = lines[i];
      if (line.contains(oldValue)) {
        changes.add(LineChange(
          lineNumber: i + 1,
          before: line,
          after: line.replaceAll(oldValue, newValue),
        ));
      }
    }

    return changes;
  }

  /// Gets file change info for a file if it contains the search text.
  ///
  /// Returns null if no matches found.
  static Future<FileChangeInfo?> getFileChangeInfo(
    File file,
    String oldValue,
    String newValue,
  ) async {
    final changes = await findMatchingLines(file, oldValue, newValue);
    if (changes.isEmpty) return null;

    return FileChangeInfo(
      filePath: file.path,
      lines: changes,
    );
  }

  /// Replaces text in a file using a regex pattern.
  ///
  /// Returns true if any replacements were made.
  static Future<bool> replaceInFileWithPattern(
    File file,
    RegExp pattern,
    String replacement,
  ) async {
    final content = await file.readAsString();
    if (!pattern.hasMatch(content)) return false;

    final updated = content.replaceAll(pattern, replacement);
    await file.writeAsString(updated);
    return true;
  }

  /// Checks if a path should be skipped during file search.
  static bool _shouldSkip(String relativePath) {
    final skipPaths = [
      '.dart_tool',
      '.git',
      'build',
      '.flutter-plugins',
      '.flutter-plugins-dependencies',
      'Pods',
      '.symlinks',
      'tool', // Don't modify the tool itself
    ];

    for (final skip in skipPaths) {
      if (relativePath.startsWith(skip) ||
          relativePath.contains('/$skip/') ||
          relativePath.contains('\\$skip\\')) {
        return true;
      }
    }

    return false;
  }

  /// Checks if a path matches a simple pattern.
  ///
  /// Supports:
  /// - Exact match: 'pubspec.yaml'
  /// - Extension match: '*.dart'
  /// - Path suffix: 'Runner/Info.plist'
  static bool _matchesPattern(String path, String pattern) {
    if (pattern.startsWith('*.')) {
      // Extension match
      final ext = pattern.substring(1);
      return path.endsWith(ext);
    } else if (pattern.contains('/') || pattern.contains('\\')) {
      // Path suffix match
      return path.endsWith(pattern) ||
          path.endsWith(pattern.replaceAll('/', '\\'));
    } else {
      // Exact filename match
      return p.basename(path) == pattern;
    }
  }

  /// Gets a file relative to the project root.
  static File getFile(Directory projectRoot, String relativePath) {
    return File(p.join(projectRoot.path, relativePath));
  }

  /// Checks if a file exists relative to the project root.
  static Future<bool> fileExists(
    Directory projectRoot,
    String relativePath,
  ) async {
    return getFile(projectRoot, relativePath).exists();
  }
}
