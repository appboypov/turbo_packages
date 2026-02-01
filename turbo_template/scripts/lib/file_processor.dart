import 'dart:io';

import 'package:path/path.dart' as p;

/// Represents a line that will be changed.
class LineChange {
  LineChange({
    required this.lineNumber,
    required this.before,
    required this.after,
  });

  final int lineNumber;
  final String before;
  final String after;
}

/// Represents changes to a single file.
class FileChangeInfo {
  FileChangeInfo({
    required this.filePath,
    required this.lines,
  });

  final String filePath;
  final List<LineChange> lines;

  int get lineCount => lines.length;
}

/// Result of processing files.
class ProcessResult {
  ProcessResult({
    required this.filesModified,
    required this.filesScanned,
    required this.filesSkipped,
    this.error,
  });

  final int filesModified;
  final int filesScanned;
  final int filesSkipped;
  final String? error;

  bool get hasError => error != null;
}

/// Utilities for file processing during template initialization.
class FileProcessor {
  /// File extensions to process (text files).
  static const processExtensions = {
    '.dart',
    '.yaml',
    '.yml',
    '.json',
    '.md',
    '.txt',
    '.xml',
    '.gradle',
    '.gradle.kts',
    '.plist',
    '.pbxproj',
    '.sh',
    '.bat',
    '.ps1',
    '.properties',
    '.env',
    '.env.example',
    '.gitignore',
    '.firebaserc',
    '.kt',
    '.java',
    '.swift',
    '.m',
    '.h',
    '.xcscheme',
    '.xcworkspacedata',
    '.entitlements',
    '.xcsettings',
    '.html',
    '.css',
    '.js',
  };

  /// File extensions to skip (binary files).
  static const skipExtensions = {
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
    '.lock',
    '.key',
    '.p12',
    '.keystore',
    '.jks',
    '.mobileprovision',
    '.provisionprofile',
  };

  /// Directories to always skip.
  static const skipDirectories = {
    '.dart_tool',
    '.git',
    'build',
    '.flutter-plugins',
    '.flutter-plugins-dependencies',
    'Pods',
    '.symlinks',
    'node_modules',
    '.gradle',
    '.idea',
    '.vscode',
    'scripts', // Don't modify the scripts themselves
  };

  /// Finds all processable files in the template root.
  static Future<List<File>> findFiles(Directory templateRoot) async {
    final files = <File>[];

    await for (final entity in templateRoot.list(recursive: true)) {
      if (entity is File) {
        final relativePath = p.relative(entity.path, from: templateRoot.path);

        if (_shouldSkip(relativePath)) continue;
        if (!_isProcessable(entity.path)) continue;

        files.add(entity);
      }
    }

    return files;
  }

  /// Replaces all occurrences of [oldValue] with [newValue] in a file.
  ///
  /// Returns true if any replacements were made.
  static Future<bool> replaceInFile(
    File file,
    String oldValue,
    String newValue,
  ) async {
    if (oldValue == newValue) return false;

    try {
      final content = await file.readAsString();
      if (!content.contains(oldValue)) return false;

      final updated = content.replaceAll(oldValue, newValue);
      await file.writeAsString(updated);
      return true;
    } catch (e) {
      // File might not be readable as text
      return false;
    }
  }

  /// Finds all lines in a file that contain the search text.
  static Future<List<LineChange>> findMatchingLines(
    File file,
    String oldValue,
    String newValue,
  ) async {
    if (oldValue == newValue) return [];

    try {
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
    } catch (e) {
      return [];
    }
  }

  /// Gets file change info for a file if it contains the search text.
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

  /// Performs multiple replacements across all files.
  static Future<ProcessResult> processFiles(
    Directory templateRoot,
    Map<String, String> replacements, {
    bool dryRun = false,
    void Function(String message)? onProgress,
  }) async {
    final files = await findFiles(templateRoot);
    var filesModified = 0;
    var filesSkipped = 0;

    for (final file in files) {
      var fileModified = false;

      for (final entry in replacements.entries) {
        final oldValue = entry.key;
        final newValue = entry.value;

        if (oldValue == newValue) continue;

        if (dryRun) {
          final changes = await findMatchingLines(file, oldValue, newValue);
          if (changes.isNotEmpty) {
            fileModified = true;
          }
        } else {
          final replaced = await replaceInFile(file, oldValue, newValue);
          if (replaced) {
            fileModified = true;
          }
        }
      }

      if (fileModified) {
        filesModified++;
        onProgress?.call(
            'Modified: ${p.relative(file.path, from: templateRoot.path)}');
      }
    }

    return ProcessResult(
      filesModified: filesModified,
      filesScanned: files.length,
      filesSkipped: filesSkipped,
    );
  }

  /// Checks if a path should be skipped during file search.
  static bool _shouldSkip(String relativePath) {
    for (final skip in skipDirectories) {
      if (relativePath.startsWith(skip) ||
          relativePath.startsWith('.$skip') ||
          relativePath.contains('/$skip/') ||
          relativePath.contains('/$skip') ||
          relativePath.contains('\\$skip\\') ||
          relativePath.contains('\\$skip')) {
        return true;
      }
    }

    // Skip files that start with a dot (hidden files except specific ones)
    final basename = p.basename(relativePath);
    if (basename.startsWith('.') &&
        !{'.firebaserc', '.gitignore', '.env', '.env.example'}
            .contains(basename)) {
      return true;
    }

    return false;
  }

  /// Checks if a file is processable based on its extension.
  static bool _isProcessable(String filePath) {
    final ext = p.extension(filePath).toLowerCase();

    // Skip binary files
    if (skipExtensions.contains(ext)) return false;

    // Process known text files
    if (processExtensions.contains(ext)) return true;

    // Check for files with no extension that are likely text
    if (ext.isEmpty) {
      final basename = p.basename(filePath).toLowerCase();
      return {'makefile', 'dockerfile', 'procfile', 'gemfile', 'podfile'}
          .contains(basename);
    }

    // Handle compound extensions
    if (filePath.endsWith('.gradle.kts')) return true;
    if (filePath.endsWith('.env.example')) return true;

    return false;
  }
}
