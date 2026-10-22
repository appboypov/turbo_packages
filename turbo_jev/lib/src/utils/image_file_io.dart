import 'dart:io';

/// The bytes of the file at [path].
///
/// Throws a [FileSystemException] when the file cannot be read.
Future<List<int>> readImageFile(String path) => File(path).readAsBytes();
