/// Thrown before sending when the Image References in a Request's content do
/// not match its Images: a reference names no known Image, or a listed Image
/// is used nowhere.
final class TJevImageReferenceException implements Exception {
  const TJevImageReferenceException({required this.reason});

  /// Which references or Images do not match.
  final String reason;

  @override
  String toString() => 'TJevImageReferenceException{reason: $reason}';
}
