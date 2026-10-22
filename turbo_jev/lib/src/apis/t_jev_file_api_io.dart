import 'dart:io';

import '../abstracts/t_jev_exception.dart';
import '../constants/t_jev_messages.dart';

/// Reads Image files from the file system.
final class TJevFileApi {
  const TJevFileApi();

  /// The bytes of the Image file at [path].
  ///
  /// Throws [TJevInvalidImageException] when the file cannot be read.
  Future<List<int>> readBytes(String path) async {
    try {
      return await File(path).readAsBytes();
    } on FileSystemException catch (error) {
      throw TJevInvalidImageException(
        message: TJevMessages.unreadableImageFile(
          path,
          error.osError?.message ?? error.message,
        ),
      );
    }
  }
}
