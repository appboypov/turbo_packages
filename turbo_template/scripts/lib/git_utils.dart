import 'dart:io';

/// Utilities for git operations.
class GitUtils {
  /// Checks if a directory is a git repository.
  static Future<bool> isGitRepository(Directory dir) async {
    final result = await Process.run(
      'git',
      ['rev-parse', '--is-inside-work-tree'],
      workingDirectory: dir.path,
    );
    return result.exitCode == 0 && result.stdout.toString().trim() == 'true';
  }

  /// Gets the current HEAD commit hash.
  static Future<String?> getCurrentHead(Directory dir) async {
    final result = await Process.run(
      'git',
      ['rev-parse', 'HEAD'],
      workingDirectory: dir.path,
    );
    if (result.exitCode != 0) return null;
    return result.stdout.toString().trim();
  }

  /// Gets the list of files changed between two commits.
  ///
  /// If [fromCommit] is null, returns all tracked files.
  static Future<List<String>> getChangedFiles(
    Directory dir, {
    String? fromCommit,
    String toCommit = 'HEAD',
  }) async {
    final List<String> args;

    if (fromCommit == null) {
      // Get all tracked files
      args = ['ls-files'];
    } else {
      // Check if fromCommit exists
      final checkResult = await Process.run(
        'git',
        ['cat-file', '-t', fromCommit],
        workingDirectory: dir.path,
      );

      if (checkResult.exitCode != 0) {
        // Commit doesn't exist, return all files
        args = ['ls-files'];
      } else {
        // Get diff between commits
        args = ['diff', '--name-only', fromCommit, toCommit];
      }
    }

    final result = await Process.run(
      'git',
      args,
      workingDirectory: dir.path,
    );

    if (result.exitCode != 0) {
      return [];
    }

    return result.stdout
        .toString()
        .split('\n')
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();
  }

  /// Checks if a commit exists in the repository.
  static Future<bool> commitExists(Directory dir, String commit) async {
    final result = await Process.run(
      'git',
      ['cat-file', '-t', commit],
      workingDirectory: dir.path,
    );
    return result.exitCode == 0;
  }

  /// Gets the short commit hash (7 characters).
  static Future<String?> getShortHash(Directory dir, String commit) async {
    final result = await Process.run(
      'git',
      ['rev-parse', '--short=7', commit],
      workingDirectory: dir.path,
    );
    if (result.exitCode != 0) return null;
    return result.stdout.toString().trim();
  }

  /// Gets the commit message for a commit.
  static Future<String?> getCommitMessage(Directory dir, String commit) async {
    final result = await Process.run(
      'git',
      ['log', '-1', '--format=%s', commit],
      workingDirectory: dir.path,
    );
    if (result.exitCode != 0) return null;
    return result.stdout.toString().trim();
  }

  /// Gets the commit count between two commits.
  static Future<int> getCommitCount(
    Directory dir, {
    required String fromCommit,
    String toCommit = 'HEAD',
  }) async {
    final result = await Process.run(
      'git',
      ['rev-list', '--count', '$fromCommit..$toCommit'],
      workingDirectory: dir.path,
    );
    if (result.exitCode != 0) return 0;
    return int.tryParse(result.stdout.toString().trim()) ?? 0;
  }
}
