import 'dart:io';

/// Reads files from the file system.
final class TJevFileApi {
  const TJevFileApi();

  /// The bytes of the file at [path].
  ///
  /// Throws a [FileSystemException] when the file cannot be read.
  Future<List<int>> readBytes(String path) => File(path).readAsBytes();
}
