part of '../abstracts/t_jev_failure.dart';

/// The API key may not use what the Request asks for (403).
final class TJevPermissionDeniedFailure extends TJevHttpFailure {
  const TJevPermissionDeniedFailure._({
    required super.status,
    required super.message,
    required super.requestId,
    required super.headers,
    required super.body,
  });
}
