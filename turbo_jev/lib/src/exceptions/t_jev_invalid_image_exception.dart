part of '../abstracts/t_jev_exception.dart';

/// Thrown when an Image is created from data that is no PNG or JPEG file.
final class TJevInvalidImageException extends TJevException {
  const TJevInvalidImageException({required this.message});

  // ⚡️ OVERRIDES

  /// What is wrong with the data.
  @override
  final String message;

  @override
  String toString() => 'TJevInvalidImageException{message: $message}';
}
