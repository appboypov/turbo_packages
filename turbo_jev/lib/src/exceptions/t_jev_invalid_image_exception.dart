/// Thrown when an Image is created from data that is no PNG or JPEG file.
final class TJevInvalidImageException implements Exception {
  const TJevInvalidImageException({required this.reason});

  /// What is wrong with the data.
  final String reason;

  @override
  String toString() => 'TJevInvalidImageException{reason: $reason}';
}
