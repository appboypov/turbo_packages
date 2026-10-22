part of '../abstracts/t_jev_failure.dart';

/// The Request or its response did not get through, for example because
/// TypeSafe could not be reached or the connection closed.
final class TJevConnectionFailure extends TJevFailure {
  @internal
  const TJevConnectionFailure({required this.message});

  // ⚡️ OVERRIDES

  @override
  String toString() => 'TJevConnectionFailure{message: $message}';

  // 🎩 STATE

  /// What went wrong with the connection.
  @override
  final String message;
}
