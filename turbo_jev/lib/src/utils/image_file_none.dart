/// Throws an [UnsupportedError]: a browser has no file system to read [path]
/// from.
Future<List<int>> readImageFile(String path) => throw UnsupportedError(
  'Reading the Image file $path needs dart:io. Create the Image from its '
  'bytes or base64 text instead.',
);
