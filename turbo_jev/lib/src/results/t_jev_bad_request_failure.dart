part of '../abstracts/t_jev_failure.dart';

/// TypeSafe rejected the Request as invalid (400), for example because a
/// Danger Zone feature was not opted in to or an Image was rejected.
final class TJevBadRequestFailure extends TJevHttpFailure {
  const TJevBadRequestFailure._({
    required super.status,
    required super.message,
    required super.requestId,
    required super.headers,
    required super.body,
  });
}
