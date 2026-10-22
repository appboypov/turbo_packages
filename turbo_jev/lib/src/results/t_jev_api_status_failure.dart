part of 't_jev_failure.dart';

/// A failure with a non-2xx HTTP status that has no failure type of its own.
final class TJevApiStatusFailure extends TJevHttpFailure {
  const TJevApiStatusFailure({
    required super.status,
    required super.requestId,
    required super.headers,
    required super.body,
  });
}
