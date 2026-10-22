part of '../abstracts/t_jev_failure.dart';

/// The caller's abort trigger completed before the Request ended, during an
/// attempt or during the wait before a retry.
final class TJevAbortedFailure extends TJevFailure {
  @internal
  const TJevAbortedFailure();

  // ⚡️ OVERRIDES

  @override
  String get message => TJevMessages.aborted;

  @override
  String toString() => 'TJevAbortedFailure{}';
}
