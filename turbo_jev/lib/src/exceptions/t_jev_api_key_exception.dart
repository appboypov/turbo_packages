/// Thrown when [TJev] is built without a valid API key.
///
/// The key comes from config, else from `TYPESAFE_API_KEY`. It must be
/// printable ASCII without spaces.
final class TJevApiKeyException implements Exception {
  const TJevApiKeyException({required this.reason});

  /// What is wrong with the API key.
  final String reason;

  @override
  String toString() => 'TJevApiKeyException{reason: $reason}';
}
