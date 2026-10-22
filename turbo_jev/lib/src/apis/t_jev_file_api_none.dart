import '../abstracts/t_jev_exception.dart';
import '../constants/t_jev_messages.dart';

/// Reads Image files where there is no file system, such as in a browser.
final class TJevFileApi {
  const TJevFileApi();

  // 🪄 MUTATORS

  /// Throws [TJevInvalidImageException]: a browser has no file system to
  /// read the Image file at [path] from.
  Future<List<int>> readBytes(String path) async =>
      throw TJevInvalidImageException(
        message: TJevMessages.imageFileWithoutFileSystem(path),
      );
}
