part of '../abstracts/t_jev_exception.dart';

/// Thrown when [TJev] is built without a valid API key.
///
/// The key comes from config, else from `TYPESAFE_API_KEY`. It must be
/// printable ASCII without spaces.
final class TJevApiKeyException extends TJevException {
  const TJevApiKeyException({required this.message});

  /// What is wrong with the API key.
  @override
  final String message;

  @override
  String toString() => 'TJevApiKeyException{message: $message}';
}
