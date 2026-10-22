part of 't_jev_failure.dart';

/// TypeSafe failed to handle the Request (5xx), including overload (529).
final class TJevInternalServerFailure extends TJevHttpFailure {
  const TJevInternalServerFailure._({
    required super.status,
    required super.message,
    required super.requestId,
    required super.headers,
    required super.body,
  });
}
