part of '../abstracts/t_jev_failure.dart';

/// TypeSafe did not find what the Request asks for (404).
final class TJevNotFoundFailure extends TJevHttpFailure {
  const TJevNotFoundFailure._({
    required super.status,
    required super.message,
    required super.requestId,
    required super.headers,
    required super.body,
  });
}
