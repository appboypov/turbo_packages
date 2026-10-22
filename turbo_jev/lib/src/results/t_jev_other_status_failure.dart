part of '../abstracts/t_jev_failure.dart';

/// A non-2xx status without a failure type of its own, such as 408, 413 or
/// 415.
final class TJevOtherStatusFailure extends TJevHttpFailure {
  const TJevOtherStatusFailure._({
    required super.status,
    required super.message,
    required super.requestId,
    required super.headers,
    required super.body,
  });
}
