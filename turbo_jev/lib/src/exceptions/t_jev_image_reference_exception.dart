part of '../abstracts/t_jev_exception.dart';

/// Thrown before sending when the Image References in a Request's content do
/// not match its Images: a reference names no known Image, or a listed Image
/// is used nowhere.
final class TJevImageReferenceException extends TJevException {
  const TJevImageReferenceException({required this.message});

  /// Which references or Images do not match.
  @override
  final String message;

  @override
  String toString() => 'TJevImageReferenceException{message: $message}';
}
