part of '../abstracts/t_jev_failure.dart';

/// TypeSafe refused the Request because the rate limit was reached (429).
final class TJevRateLimitFailure extends TJevHttpFailure {
  const TJevRateLimitFailure._({
    required super.status,
    required super.message,
    required super.requestId,
    required super.headers,
    required super.body,
    required this.retryAfter,
  });

  /// How long TypeSafe asks to wait before trying again, or `null` when it
  /// gave no valid delay.
  ///
  /// It is read from `retry-after-ms` first and from `Retry-After` second,
  /// in seconds or as an HTTP date.
  final Duration? retryAfter;
}
